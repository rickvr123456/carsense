import 'package:flutter/foundation.dart';
import 'features/dashboard/dashboard_state.dart';
import 'core/models/dtc.dart';

class AppState extends ChangeNotifier {
  AppState() {
    dashboard.addListener(_onDashboardChanged);
  }

  final DashboardState dashboard = DashboardState();

  List<Dtc> get dtcs => dashboard.dtcs;

  void _onDashboardChanged() {
    notifyListeners();
  }

  void clearDtc() {
    dashboard.clearDtc();
  }

  @override
  void dispose() {
    dashboard.removeListener(_onDashboardChanged);
    dashboard.dispose();
    super.dispose();
  }
}
