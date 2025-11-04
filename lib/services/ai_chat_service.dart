import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'network_helper.dart';

class AiMessage {
  AiMessage({
    required this.role,
    required this.text,
    this.isLoading = false,
    DateTime? ts,
  }) : ts = ts ?? DateTime.now();

  final String role; // user | model
  final String text;
  final bool isLoading;
  final DateTime ts;

  AiMessage copyWith({String? text, bool? isLoading}) => AiMessage(
        role: role,
        text: text ?? this.text,
        isLoading: isLoading ?? this.isLoading,
        ts: ts,
      );

  @override
  String toString() =>
      'AiMessage(role: $role, text: ${text.substring(0, text.length.clamp(0, 50))}..., isLoading: $isLoading)';
}

class AiChatService extends ChangeNotifier {
  AiChatService({required String apiKey, String modelName = 'gemini-2.5-flash'})
      : _model = GenerativeModel(model: modelName, apiKey: apiKey) {
    _chat = _model.startChat();
  }

  final GenerativeModel _model;
  late ChatSession _chat;

  final List<AiMessage> _history = [];
  List<AiMessage> get history => List.unmodifiable(_history);

  bool sending = false;
  String? lastError;

  static const String _systemPrompt = '''
D'ora in poi rispondi SEMPRE in testo semplice, senza titoli, grassetti o markdown.
Puoi usare al massimo brevi elenchi puntati.
Mantieni la risposta concisa, facile da leggere e naturale in italiano.
''';

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

    _history.add(AiMessage(role: 'user', text: text));
    _history.add(AiMessage(role: 'model', text: '...', isLoading: true));
    notifyListeners();

    final hasNetwork = await NetworkHelper.hasConnection();
    if (!hasNetwork) {
      lastError = 'Nessuna connessione a Internet';
      _replaceLoadingWith(
        AiMessage(
            role: 'model', text: 'Errore: Nessuna connessione a Internet'),
      );
      sending = false;
      notifyListeners();
      return;
    }

    try {
      await _chat.sendMessage(Content.text(_systemPrompt));

      final stream = _chat
          .sendMessageStream(Content.text(text))
          .timeout(const Duration(seconds: 30));

      final buffer = StringBuffer();

      await for (final chunk in stream) {
        final t = chunk.text ?? '';
        if (t.isEmpty) continue;
        buffer.write(t);
        _updateStreaming(buffer.toString());
      }

      _finalizeStreaming(buffer.toString());
    } on TimeoutException {
      lastError = 'Timeout: la richiesta ha impiegato troppo tempo';
      _replaceLoadingWith(
        AiMessage(
            role: 'model',
            text: 'Timeout: la richiesta ha impiegato troppo tempo. Riprova.'),
      );
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException') ||
          e.toString().contains('Failed host lookup')) {
        lastError = 'Nessuna connessione a Internet';
      } else {
        lastError = 'Errore nella comunicazione con l\'AI';
      }

      _replaceLoadingWith(
        AiMessage(role: 'model', text: 'Si è verificato un errore. Riprova.'),
      );
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  void _updateStreaming(String text) {
    final idx =
        _history.lastIndexWhere((m) => m.isLoading && m.role == 'model');
    if (idx != -1) {
      _history[idx] = AiMessage(role: 'model', text: text, isLoading: true);
    }
    notifyListeners();
  }

  void _finalizeStreaming(String text) {
    final idx =
        _history.lastIndexWhere((m) => m.isLoading && m.role == 'model');
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
