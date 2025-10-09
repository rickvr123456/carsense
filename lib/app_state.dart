import 'package:flutter/foundation.dart';
import 'features/dashboard/dashboard_state.dart';
import 'core/models/dtc.dart';

/// Stato applicativo condiviso tra le schermate.
/// Contiene lo stato dashboard e un accesso ai DTC per la pagina Problemi.
class AppState extends ChangeNotifier {
  final DashboardState dashboard = DashboardState();

  List<Dtc> get dtcs => dashboard.dtcs;

  void clearDtc() {
    dashboard.clearDtc();
    notifyListeners();
  }
}
