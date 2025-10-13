import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../core/models/dtc.dart';
import '../../services/error_history_service.dart';

final _history = ErrorHistoryService();


class DashboardState extends ChangeNotifier {
  bool connected = false;
  int rpm = 0;
  int speed = 0;
  double batteryV = 0;
  int coolantC = 0;

  final List<Dtc> _dtcs = [];
  List<Dtc> get dtcs => List.unmodifiable(_dtcs);

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
    _dtcs.add(Dtc(code));
    _history.addError(code); // ← Salva ogni codice generato
  }
}


  String _randomDtc(Random r) {
    const types = ['P', 'B', 'C', 'U'];
    String digits(int n) => List.generate(n, (_) => r.nextInt(10)).join();
    return '${types[r.nextInt(types.length)]}${digits(4)}';
  }

  void removeDtcCodes(Set<String> codes) {
  _dtcs.removeWhere((dtc) => codes.contains(dtc.code));
  notifyListeners();
  }
}
