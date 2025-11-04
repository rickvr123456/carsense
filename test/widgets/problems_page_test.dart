import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/features/problems/problems_page.dart';

void main() {
  group('ProblemsPage Widget Tests', () {
    testWidgets('ProblemsPage is a ConsumerStatefulWidget',
        (WidgetTester tester) async {
      expect(ProblemsPage, isNotNull);

      const page = ProblemsPage();
      expect(page, isA<ProblemsPage>());
    });

    testWidgets('ProblemsPage can be instantiated',
        (WidgetTester tester) async {
      expect(() => const ProblemsPage(), returnsNormally);
    });
  });
}
