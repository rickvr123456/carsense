import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/services/error_history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ErrorHistoryService Tests', () {
    late ErrorHistoryService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = ErrorHistoryService();
    });

    tearDown(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    test('ErrorHistoryService should return empty list initially', () async {
      final history = await service.getHistory();
      expect(history, isEmpty);
    });

    test('ErrorHistoryService should add and retrieve errors', () async {
      await service.addError('P0123');
      final history = await service.getHistory();

      expect(history.length, 1);
      expect(history[0]['code'], 'P0123');
      expect(history[0]['timestamp'], isNotNull);
    });

    test('ErrorHistoryService should clear history', () async {
      await service.addError('P0123');
      await service.clearHistory();

      final history = await service.getHistory();
      expect(history, isEmpty);
    });
  });
}
