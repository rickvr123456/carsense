import 'package:flutter/foundation.dart';
import 'features/dashboard/dashboard_state.dart';
import 'core/models/dtc.dart';

/// Stato applicativo condiviso tra le schermate.
/// Contiene lo stato dashboard e un accesso ai DTC per la pagina Problemi.
class AppState extends ChangeNotifier {
  AppState() {
    // Ascolta i cambiamenti di DashboardState e propaga ai listener di AppState
    dashboard.addListener(_onDashboardChanged);
  }

  final DashboardState dashboard = DashboardState();

  List<Dtc> get dtcs => dashboard.dtcs;

  void _onDashboardChanged() {
    // Propaga le notifiche di DashboardState ai listener di AppState
    notifyListeners();
  }

  void clearDtc() {
    dashboard.clearDtc();
    // Non serve notifyListeners() qui perché DashboardState già lo fa
    // e noi lo propaghiamo tramite _onDashboardChanged
  }

  @override
  void dispose() {
    dashboard.removeListener(_onDashboardChanged);
    dashboard.dispose();
    super.dispose();
  }
}
