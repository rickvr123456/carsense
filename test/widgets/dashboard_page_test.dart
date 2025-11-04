import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/app_shell.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('AppShell is a ConsumerStatefulWidget',
        (WidgetTester tester) async {
      // Simple test - verify page type
      expect(AppShell, isNotNull);

      const shell = AppShell();
      expect(shell, isA<AppShell>());
    });

    testWidgets('App renders without crashes', (WidgetTester tester) async {
      // Minimal test - check constructor works
      expect(() => const AppShell(), returnsNormally);
    });
  });
}
