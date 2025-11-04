import 'dart:convert';
import 'dart:async';
import 'package:carsense/core/models/dtc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/app_constants.dart';

class GeminiService {
  GeminiService({
    required String apiKey,
    String modelName = 'gemini-2.5-flash',
  }) : model = GenerativeModel(model: modelName, apiKey: apiKey);

  final GenerativeModel model;

  /// Chiede a Gemini di generare titolo e descrizione sintetica per ciascun codice OBD
  Future<Map<String, Dtc>> describeDtcs(List<String> dtcCodes) async {
    if (dtcCodes.isEmpty) {
      return {};
    }

    final prompt = _buildPrompt(dtcCodes);

    try {
      final contents = [Content.text(prompt)];

      // Add timeout to prevent hanging requests
      final response = await model
          .generateContent(contents)
          .timeout(AppConstants.networkTimeout);

      final text = response.text;

      return _parseJsonResponse(text ?? '');
    } on TimeoutException {
      return {};
    } catch (e) {
      return {};
    }
  }

  String _buildPrompt(List<String> dtcCodes) {
    return '''Rispondi con SOLO un oggetto JSON valido, senza alcun testo aggiuntivo prima o dopo.

{
  "P0340": {
    "title": "Sensore albero a camme malfunzionante",
    "description": "Errore nel circuito del sensore posizione albero a camme rilevato dal controller motore."
  }
}

Per questi codici OBD-II, genera titolo (sintetico) e description (1-2 frasi in italiano):
${dtcCodes.join(', ')}
''';
  }

  Map<String, Dtc> _parseJsonResponse(String text) {
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) {
        final result = <String, Dtc>{};
        decoded.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            final title = value['title']?.toString();
            final description = value['description']?.toString();
            result[key.toUpperCase()] =
                Dtc(key.toUpperCase(), title: title, description: description);
          }
        });
        return result;
      }
    } catch (e) {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        final sub = text.substring(start, end + 1);
        try {
          final decoded = jsonDecode(sub);
          if (decoded is Map<String, dynamic>) {
            final result = <String, Dtc>{};
            decoded.forEach((key, value) {
              if (value is Map<String, dynamic>) {
                final title = value['title']?.toString();
                final description = value['description']?.toString();
                result[key.toUpperCase()] = Dtc(key.toUpperCase(),
                    title: title, description: description);
              }
            });
            return result;
          }
        } catch (e2) {
          // Fallback parsing failed, return empty
        }
      }
      return {};
    }
    return {};
  }
}
