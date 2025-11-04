import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/constants/app_constants.dart';

class ErrorHistoryService {
  Future<void> addError(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getHistory();
    final now = DateTime.now().toIso8601String();
    list.add({'code': code, 'timestamp': now});
    await prefs.setString(AppConstants.errorHistoryKey, json.encode(list));
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(AppConstants.errorHistoryKey);
    if (data == null) return [];
    try {
      final decoded = json.decode(data);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      return [];
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.errorHistoryKey);
  }
}
