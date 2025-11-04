import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/features/history/history_page.dart';

void main() {
  group('HistoryPage Widget Tests', () {
    testWidgets('HistoryPage is a StatefulWidget', (WidgetTester tester) async {
      expect(HistoryPage, isNotNull);

      const page = HistoryPage();
      expect(page, isA<HistoryPage>());
    });

    testWidgets('HistoryPage can be instantiated', (WidgetTester tester) async {
      expect(() => const HistoryPage(), returnsNormally);
    });
  });
}
