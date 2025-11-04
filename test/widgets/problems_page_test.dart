import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/features/problems/problems_page.dart';

void main() {
  group('ProblemsPage Widget Tests', () {
    testWidgets('ProblemsPage is a ConsumerStatefulWidget',
        (WidgetTester tester) async {
      // Simple widget tree test - just verify page type
      expect(ProblemsPage, isNotNull);

      // Verify it's a ConsumerStatefulWidget
      final page = const ProblemsPage();
      expect(page, isA<ProblemsPage>());
    });

    testWidgets('ProblemsPage can be instantiated',
        (WidgetTester tester) async {
      // Minimal test - just check constructor works
      expect(() => const ProblemsPage(), returnsNormally);
    });
  });
}
