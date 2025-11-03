import 'package:flutter_test/flutter_test.dart';
import 'package:carsense/services/gemini_service.dart';
import 'package:carsense/core/models/dtc.dart';

void main() {
  group('GeminiService Tests', () {
    late GeminiService geminiService;

    setUp(() {
      geminiService = GeminiService(
        apiKey: 'test_api_key_dummy_AIzaSyBO9nCSYlXMYVbtV8Pe8_JoSZiivGm17A',
        modelName: 'gemini-2.5-flash',
      );
    });

    test('GeminiService should initialize correctly', () {
      expect(geminiService.model, isNotNull);
    });

    test('GeminiService should handle empty code list', () async {
      final result = await geminiService.describeDtcs([]);
      expect(result, isEmpty);
    });

    test('Dtc model should be created with all fields', () {
      final dtc = Dtc(
        'P0340',
        title: 'Sensore posizione albero a camme',
        description: 'Errore nel sensore CMP',
      );

      expect(dtc.code, 'P0340');
      expect(dtc.title, 'Sensore posizione albero a camme');
      expect(dtc.description, 'Errore nel sensore CMP');
    });
  });
}
