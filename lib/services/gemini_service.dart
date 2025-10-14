import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servizio per ottenere descrizioni DTC da Gemini (Generative Language API).
/// Usa il modello gemini-2.5-flash via REST.
/// Nota: proteggi la API key; in produzione usa backend o secret manager.
class GeminiService {
  final String apiKey;
  final String model;
  final Uri endpoint;

  GeminiService({
    required this.apiKey,
    this.model = 'gemini-2.5-flash',
  }) : endpoint = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
        );

  /// Chiede descrizioni sintetiche in IT per ciascun codice.
  /// Restituisce { 'P0340': 'descrizione...', ... }.
  Future<Map<String, String>> describeDtcs(List<String> dtcCodes) async {
    if (dtcCodes.isEmpty) return {};

    final systemInstruction = '''
Sei un assistente tecnico automotive. Per ogni codice OBD-II fornito (P/B/C/U + 4 cifre) restituisci UNA descrizione sintetica in italiano di 1–2 frasi per l'utente, senza consigli di riparazione, senza formattazioni speciali.
Devi rispondere esclusivamente in JSON valido con chiavi uguali ai codici e valori testuali.
Esempio di risposta:
{
  "P0340": "Malfunzionamento circuito sensore posizione albero a camme."
}
    ''';

    final userContent = 'Codici: ${dtcCodes.join(', ')}';

    final body = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': '$systemInstruction\n$userContent'}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'topK': 40,
        'topP': 0.9,
        'maxOutputTokens': 512
      }
    };

    final res = await http.post(
      endpoint,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      return {};
    }

    final data = jsonDecode(res.body);
    final candidates = data['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) return {};

    final text = (candidates.first['content']?['parts'] as List?)?.first['text']
        as String?;
    if (text == null) return {};

    try {
      final parsed = jsonDecode(text);
      final map = <String, String>{};
      parsed.forEach((k, v) {
        if (k is String && v is String) {
          map[k.toUpperCase()] = v.trim();
        }
      });
      return map;
    } catch (_) {
      return {};
    }
  }
}
