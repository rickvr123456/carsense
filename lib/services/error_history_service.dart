import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ErrorHistoryService {
  static const String _key = 'obd_errors';

  Future<void> addError(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getHistory();
    final now = DateTime.now().toIso8601String();
    list.add({'code': code, 'timestamp': now});
    await prefs.setString(_key, json.encode(list));
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
