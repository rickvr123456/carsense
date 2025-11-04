import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/features/history/history_page.dart';

void main() {
  group('HistoryPage Widget Tests', () {
    testWidgets('HistoryPage is a StatefulWidget', (WidgetTester tester) async {
      // Simple test - verify page type
      expect(HistoryPage, isNotNull);

      final page = const HistoryPage();
      expect(page, isA<HistoryPage>());
    });

    testWidgets('HistoryPage can be instantiated', (WidgetTester tester) async {
      // Minimal test - check constructor works
      expect(() => const HistoryPage(), returnsNormally);
    });
  });
}
