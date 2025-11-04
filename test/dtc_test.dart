import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/core/models/dtc.dart';

void main() {
  group('Dtc class tests', () {
    test('should create Dtc instance with required code and optional fields',
        () {
      const dtc = Dtc(
        'P0123',
        title: 'Throttle Position Sensor',
        description: 'Sensor malfunction detected',
        detail: 'Sensor reading out of range',
      );

      expect(dtc.code, 'P0123');
      expect(dtc.title, 'Throttle Position Sensor');
      expect(dtc.description, 'Sensor malfunction detected');
      expect(dtc.detail, 'Sensor reading out of range');
    });

    test('should allow optional fields to be null', () {
      const dtc = Dtc('P0456');

      expect(dtc.code, 'P0456');
      expect(dtc.title, isNull);
      expect(dtc.description, isNull);
      expect(dtc.detail, isNull);
    });
  });
}
