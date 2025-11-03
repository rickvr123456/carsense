import 'dart:convert';
import 'dart:async';
import 'package:carsense/core/models/dtc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../riverpod_providers.dart';
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
      globalLogger.d('[Gemini] Nessun codice da descrivere');
      return {};
    }

    final prompt = _buildPrompt(dtcCodes);

    try {
      globalLogger.d(
          '[Gemini] Invio prompt: ${prompt.substring(0, prompt.length.clamp(0, 300))}');
      final contents = [Content.text(prompt)];

      // Add timeout to prevent hanging requests
      final response = await model
          .generateContent(contents)
          .timeout(AppConstants.networkTimeout);

      final text = response.text;
      globalLogger.d(
          '[Gemini] Risposta: ${text?.substring(0, text.length.clamp(0, 400)) ?? "<vuoto>"}');

      return _parseJsonResponse(text ?? '');
    } on TimeoutException {
      globalLogger.e('[Gemini][TIMEOUT] Request timed out');
      return {};
    } catch (e, st) {
      globalLogger.e('[Gemini][ERRORE] $e');
      globalLogger.e(st.toString());
      return {};
    }
  }

  String _buildPrompt(List<String> dtcCodes) {
    return '''
Sei un assistente tecnico automotive. Per ogni codice OBD-II fornito (formato P/B/C/U + 4 cifre), restituisci un oggetto con "title" (titolo sintetico) e "description" (descrizione di 1-2 frasi) in italiano. Rispondi con un JSON valido contenente tutte le chiavi come codici e valori come oggetti con questi campi.

Esempio:
{
  "P0340": {
    "title": "Sensore albero a camme malfunzionante",
    "description": "Errore nel circuito del sensore posizione albero a camme rilevato dal controller motore."
  }
}

Codici: ${dtcCodes.join(', ')}
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
        globalLogger.d('[Gemini] Parsed ${result.length} DTC dettagliati.');
        return result;
      }
    } catch (e) {
      globalLogger.e('[Gemini] Errore parsing JSON: $e');
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
            globalLogger.d(
                '[Gemini] Parsed (fallback) ${result.length} DTC dettagliati.');
            return result;
          }
        } catch (e2) {
          globalLogger.e('[Gemini] Fallback parse fallito: $e2');
        }
      }
      return {};
    }
    return {};
  }
}
