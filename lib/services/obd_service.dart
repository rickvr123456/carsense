import 'dart:convert';
import 'package:http/http.dart' as http;

class ObdService {
  final String baseUrl;
  final String? apiKey; // se richiesto
  ObdService({required this.baseUrl, this.apiKey});

  Future<ObdInfo?> fetchDtc(String code) async {
    // Esempio: GET {baseUrl}/api/obd-codes?code=P0340
    final uri = Uri.parse('$baseUrl/api/obd-codes?code=$code');
    final headers = <String, String>{
      'Accept': 'application/json',
      if (apiKey != null) 'Authorization': 'Bearer $apiKey',
    };
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) return _fallback(code);

    final data = json.decode(res.body);
    // Adatta il parsing al formato della tua API; sotto un mapping comune:
    // data['data'] potrebbe essere una lista di record con 'code' e 'description'
    final list = (data['data'] as List?) ?? [];
    if (list.isEmpty) return _fallback(code);

    final item = list.firstWhere(
      (e) => (e['code'] as String).toUpperCase() == code.toUpperCase(),
      orElse: () => list.first,
    );

    final description = (item['description'] as String?)?.trim();
    return ObdInfo(
      code: code.toUpperCase(),
      title: _titleFromCode(code),
      summary: description ?? 'Descrizione non disponibile',
    );
  }

  // Titolo sintetico in base al prefisso del codice
  String _titleFromCode(String code) {
    final c = code.toUpperCase();
    if (c.startsWith('P')) return 'Powertrain';
    if (c.startsWith('B')) return 'Body';
    if (c.startsWith('C')) return 'Chassis';
    if (c.startsWith('U')) return 'Network';
    return 'DTC';
  }

  // Fallback minimale per alcuni codici comuni (utile in demo/offline)
  ObdInfo? _fallback(String code) {
    final map = <String, String>{
      'P0340':
          'Malfunzionamento circuito sensore posizione albero a camme (CMP).',
      'P0300': 'Mancate accensioni multiple o casuali rilevate.',
    };
    final desc = map[code.toUpperCase()];
    if (desc == null) return null;
    return ObdInfo(
        code: code.toUpperCase(), title: _titleFromCode(code), summary: desc);
  }
}

class ObdInfo {
  final String code;
  final String title;
  final String summary;
  ObdInfo({required this.code, required this.title, required this.summary});
}
