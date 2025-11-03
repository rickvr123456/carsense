import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../core/models/dtc.dart';
import '../../services/error_history_service.dart';
import '../../services/gemini_service.dart';
import '../../services/network_helper.dart';
import '../../riverpod_providers.dart';

/// Enum per i tipi di errore del dashboard
enum ErrorType { none, network, ai, timeout }

/// Classe che rappresenta lo stato di errore
class ErrorState {
  const ErrorState({
    required this.type,
    this.message,
  });

  final ErrorType type;
  final String? message;

  bool get hasError => type != ErrorType.none;

  ErrorState copyWith({
    ErrorType? type,
    String? message,
  }) =>
      ErrorState(
        type: type ?? this.type,
        message: message ?? this.message,
      );

  static const ErrorState none = ErrorState(type: ErrorType.none);
}

class DashboardState extends ChangeNotifier {
  bool connected = false;
  bool isScanning = false;
  int rpm = 0;
  int speed = 0;
  double batteryV = 0;
  int coolantC = 0;

  final List<Dtc> _dtcs = [];
  List<Dtc> get dtcs => List.unmodifiable(List.from(_dtcs));

  final _history = ErrorHistoryService();

  // Unified error state
  ErrorState errorState = ErrorState.none;

  // Deprecated: kept for backward compatibility during migration
  String? get lastNetworkError =>
      errorState.type == ErrorType.network ? errorState.message : null;
  set lastNetworkError(String? value) {
    if (value != null) {
      _setError(ErrorType.network, value);
    } else {
      _clearError();
    }
  }

  String? get lastAiError =>
      errorState.type == ErrorType.ai ? errorState.message : null;
  set lastAiError(String? value) {
    if (value != null) {
      _setError(ErrorType.ai, value);
    } else {
      _clearError();
    }
  }

  bool get hasAiError => errorState.type == ErrorType.ai;
  set hasAiError(bool value) {
    if (value && errorState.type != ErrorType.ai) {
      _setError(ErrorType.ai, 'Errore AI');
    } else if (!value) {
      _clearError();
    }
  }

  GeminiService? _gemini;
  GeminiService? get gemini => _gemini;

  void attachGemini(GeminiService service) {
    _gemini = service;
    globalLogger.d('[Dashboard] GeminiService collegato.');
  }

  void _setError(ErrorType type, String message) {
    errorState = ErrorState(type: type, message: message);
    notifyListeners();
  }

  void _clearError() {
    errorState = ErrorState.none;
    notifyListeners();
  }

  void toggleConnectionAndScan() {
    connected = !connected;
    if (connected) {
      _performScan();
    } else {
      _clearLiveValues();
      notifyListeners();
    }
  }

  void rescan() {
    if (!connected) return;
    _performScan();
  }

  /// Esegue la scansione: simula valori, genera DTC e chiama AI
  void _performScan() {
    isScanning = true;
    _simulateLiveValues();
    _generateRandomDTCs();
    notifyListeners();
  }

  /// Riprova a interpretare solo i DTC non ancora interpretati
  void retryAiDescription() {
    final uninterpretedDtcs =
        _dtcs.where((d) => d.title == null || d.title!.isEmpty).toList();
    if (uninterpretedDtcs.isEmpty) {
      globalLogger.d('[Dashboard] Tutti i DTC sono già stati interpretati.');
      return;
    }
    isScanning = true;
    notifyListeners();
    _describeWithAI();
  }

  void clearDtc() {
    _dtcs.clear();
    notifyListeners();
  }

  void removeDtcCodes(Set<String> codes) {
    _dtcs.removeWhere((d) => codes.contains(d.code));
    notifyListeners();
  }

  void _simulateLiveValues() {
    final r = Random();
    rpm = 700 + r.nextInt(3500);
    speed = r.nextInt(130);
    batteryV = double.parse((12.0 + r.nextDouble() * 2.5).toStringAsFixed(1));
    coolantC = 60 + r.nextInt(50);
  }

  void _clearLiveValues() {
    rpm = 0;
    speed = 0;
    batteryV = 0;
    coolantC = 0;
    _dtcs.clear();
  }

  void _generateRandomDTCs() {
    _dtcs.clear();
    final r = Random();
    final count = r.nextInt(4);
    for (int i = 0; i < count; i++) {
      final code = _randomDtc(r);
      final dtc = Dtc(code);
      _dtcs.add(dtc);
      _history.addError(code);
    }
    _describeWithAI();
  }

  String _randomDtc(Random r) {
    const types = ['P', 'B', 'C', 'U'];
    String digits(int n) => List.generate(n, (_) => r.nextInt(10)).join();
    return '${types[r.nextInt(types.length)]}${digits(4)}';
  }

  Future<void> _describeWithAI() async {
    if (_gemini == null || _dtcs.isEmpty) {
      globalLogger
          .d('[Dashboard] GeminiService non collegato o lista DTC vuota.');
      isScanning = false;
      notifyListeners();
      return;
    }

    // Check network connectivity
    final hasNetwork = await NetworkHelper.hasConnection();
    if (!hasNetwork) {
      _setError(ErrorType.network, 'Nessuna connessione a Internet');
      isScanning = false;
      globalLogger.e('[Dashboard] Nessuna connessione a Internet');
      return;
    }

    try {
      _clearError();
      final codes = _dtcs.map((e) => e.code).toList();
      globalLogger.d('[Dashboard] Richiedo descrizioni a Gemini per: $codes');
      final map = await _gemini!.describeDtcs(codes);
      if (map.isEmpty) {
        globalLogger.d('[Dashboard] Nessuna descrizione ricevuta da Gemini.');
        _setError(
          ErrorType.ai,
          'L\'AI non ha fornito descrizioni per i codici rilevati.',
        );
        isScanning = false;
        return;
      }
      // Replace DTCs with updated copies instead of mutating
      for (int i = 0; i < _dtcs.length; i++) {
        final d = _dtcs[i];
        final aiDtc = map[d.code.toUpperCase()];
        if (aiDtc != null) {
          _dtcs[i] = d.copyWith(
            title: aiDtc.title ?? d.title,
            description: aiDtc.description ?? d.description,
          );
        }
      }
      globalLogger.d('[Dashboard] Descrizioni AI impostate.');
      isScanning = false;
      notifyListeners();
    } on TimeoutException {
      _setError(ErrorType.timeout, 'Timeout: la richiesta ha impiegato troppo tempo');
      isScanning = false;
      globalLogger.e('[Dashboard][TIMEOUT]');
    } catch (e, st) {
      _setError(ErrorType.ai, e.toString());
      isScanning = false;
      globalLogger.e('[Dashboard][ERRORE AI] $e');
      globalLogger.e(st.toString());
    }
  }
}
