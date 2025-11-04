import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/services/error_history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Integration Tests - Complete Flow', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('Error history service integrates with persistence', () async {
      final historyService = ErrorHistoryService();

      var history = await historyService.getHistory();
      expect(history, isEmpty);

      await historyService.addError('P0123');
      await historyService.addError('P0456');
      history = await historyService.getHistory();

      expect(history.length, 2);
      expect(history[0]['code'], 'P0123');
      expect(history[1]['code'], 'P0456');

      await historyService.clearHistory();
      final emptyHistory = await historyService.getHistory();
      expect(emptyHistory, isEmpty);
    });

    test('Multiple error codes can be stored and retrieved', () async {
      final historyService = ErrorHistoryService();

      final codes = ['P0100', 'P0200', 'P0300', 'P0400', 'P0500'];
      for (final code in codes) {
        await historyService.addError(code);
      }

      final history = await historyService.getHistory();
      expect(history.length, codes.length);

      for (int i = 0; i < codes.length; i++) {
        expect(history[i]['code'], codes[i]);
      }
    });
  });
}
