import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiMessage {
  final String role; // user | model
  final String text;
  final bool isLoading;
  final DateTime ts;
  AiMessage({
    required this.role,
    required this.text,
    this.isLoading = false,
    DateTime? ts,
  }) : ts = ts ?? DateTime.now();

  AiMessage copyWith({String? text, bool? isLoading}) =>
      AiMessage(role: role, text: text ?? this.text, isLoading: isLoading ?? this.isLoading);
}

class AiChatService extends ChangeNotifier {
  final GenerativeModel _model;
  late ChatSession _chat;

  final List<AiMessage> _history = [];
  List<AiMessage> get history => List.unmodifiable(_history);

  bool sending = false;
  String? lastError;

  // Prompt invisibile
  static const String _systemPrompt = '''
D'ora in poi rispondi SEMPRE in testo semplice, senza titoli, grassetti o markdown.
Puoi usare al massimo brevi elenchi puntati.
Mantieni la risposta concisa, facile da leggere e naturale in italiano.
''';

  AiChatService({required String apiKey, String modelName = 'gemini-2.5-flash'})
      : _model = GenerativeModel(model: modelName, apiKey: apiKey) {
    _chat = _model.startChat();
  }

  Future<void> reset({bool savePrevious = false}) async {
    _history.clear();
    lastError = null;
    _chat = _model.startChat();
    notifyListeners();
  }

  Future<void> send(String userText) async {
    final text = userText.trim();
    if (text.isEmpty || sending) return;

    sending = true;
    lastError = null;

    // Mostra subito il messaggio dell’utente
    _history.add(AiMessage(role: 'user', text: text));
    // Messaggio di caricamento per il modello
    _history.add(AiMessage(role: 'model', text: '...', isLoading: true));
    notifyListeners();

    try {
      await _chat.sendMessage(Content.text(_systemPrompt));
      final stream = await _chat.sendMessageStream(Content.text(text));
      final buffer = StringBuffer();

      await for (final chunk in stream) {
        final t = chunk.text ?? '';
        if (t.isEmpty) continue;
        buffer.write(t);
        _updateStreaming(buffer.toString());
      }

      _finalizeStreaming(buffer.toString());
    } catch (e, st) {
      debugPrint('[AiChat ERROR] $e\n$st');
      lastError = 'Errore: $e';
      _replaceLoadingWith(
        AiMessage(role: 'model', text: 'Si è verificato un errore. Riprova.'),
      );
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  void _updateStreaming(String text) {
    final idx = _history.lastIndexWhere((m) => m.isLoading && m.role == 'model');
    if (idx != -1) {
      _history[idx] = AiMessage(role: 'model', text: text, isLoading: true);
    }
    notifyListeners();
  }

  void _finalizeStreaming(String text) {
    final idx = _history.lastIndexWhere((m) => m.isLoading && m.role == 'model');
    if (idx != -1) {
      _history[idx] = AiMessage(role: 'model', text: text, isLoading: false);
    }
    notifyListeners();
  }

  void _replaceLoadingWith(AiMessage msg) {
    final idx = _history.lastIndexWhere((m) => m.isLoading);
    if (idx != -1) {
      _history[idx] = msg;
    }
    notifyListeners();
  }
}
