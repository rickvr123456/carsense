import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../core/models/dtc.dart';
import '../../services/gemini_service.dart';
import '../../services/error_history_service.dart';

class DashboardState extends ChangeNotifier {
  bool connected = false;
  int rpm = 0;
  int speed = 0;
  double batteryV = 0;
  int coolantC = 0;

  final List<Dtc> _dtcs = [];
  List<Dtc> get dtcs => List.unmodifiable(_dtcs);

  final _history = ErrorHistoryService();

  GeminiService? _gemini;
  void attachGemini(GeminiService service) {
    _gemini = service;
  }

  void toggleConnectionAndScan() {
    connected = !connected;
    if (connected) {
      _simulateLiveValues();
      _generateRandomDTCs();
    } else {
      _clearLiveValues();
    }
    notifyListeners();
  }

  void rescan() {
    if (!connected) return;
    _simulateLiveValues();
    _generateRandomDTCs();
    notifyListeners();
  }

  void clearDtc() {
    _dtcs.clear();
    notifyListeners();
  }

  void removeDtcCodes(Set<String> codes) {
    _dtcs.removeWhere((dtc) => codes.contains(dtc.code));
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
    final count = r.nextInt(4); // 0–3 errori
    for (int i = 0; i < count; i++) {
      final code = _randomDtc(r);
      final dtc = Dtc(code);
      _dtcs.add(dtc);
      _history.addError(code); // persistenza nella cronologia
    }
    // Subito dopo la generazione, chiedi a Gemini le descrizioni
    _describeWithAI();
  }

  String _randomDtc(Random r) {
    const types = ['P', 'B', 'C', 'U'];
    String digits(int n) => List.generate(n, (_) => r.nextInt(10)).join();
    return '${types[r.nextInt(types.length)]}${digits(4)}';
  }

  Future<void> _describeWithAI() async {
    if (_gemini == null || _dtcs.isEmpty) return;
    try {
      final codes = _dtcs.map((e) => e.code).toList();
      final map = await _gemini!.describeDtcs(codes);
      if (map.isEmpty) return;
      for (final d in _dtcs) {
        final desc = map[d.code.toUpperCase()];
        if (desc != null && (d.description == null || d.description!.isEmpty)) {
          d.description = desc;
        }
      }
      notifyListeners();
    } catch (_) {
      // errore silenziato per non interrompere l'esperienza
    }
  }
}
