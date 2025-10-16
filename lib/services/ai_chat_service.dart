import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiMessage {
  final String role; // 'user' | 'model'
  final String text;
  final DateTime ts;
  AiMessage({required this.role, required this.text, DateTime? ts})
      : ts = ts ?? DateTime.now();
}

class AiChatService extends ChangeNotifier {
  final GenerativeModel _model;
  late ChatSession _chat;

  final List<AiMessage> _history = [];
  List<AiMessage> get history => List.unmodifiable(_history);

  bool sending = false;
  String? lastError;

  AiChatService({required String apiKey, String modelName = 'gemini-1.5-flash'})
      : _model = GenerativeModel(model: modelName, apiKey: apiKey) {
    _chat = _model.startChat();
  }

  Future<void> reset() async {
    _history.clear();
    lastError = null;
    _chat = _model.startChat();
    notifyListeners();
  }

  Future<void> send(String userText) async {
    final text = userText.trim();
    if (text.isEmpty) return;
    if (sending) return;

    lastError = null;
    sending = true;
    _history.add(AiMessage(role: 'user', text: text));
    notifyListeners();

    try {
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
      debugPrint('[AiChat] ERROR: $e\n$st');
      lastError = '$e';
      _history.add(AiMessage(
          role: 'model', text: 'Si è verificato un errore. Riprova.'));
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  void _updateStreaming(String text) {
    if (_history.isNotEmpty && _history.last.role == 'model') {
      _history[_history.length - 1] = AiMessage(role: 'model', text: text);
    } else {
      _history.add(AiMessage(role: 'model', text: text));
    }
    notifyListeners();
  }

  void _finalizeStreaming(String text) {
    if (text.isEmpty) return;
    if (_history.isNotEmpty && _history.last.role == 'model') {
      _history[_history.length - 1] = AiMessage(role: 'model', text: text);
    } else {
      _history.add(AiMessage(role: 'model', text: text));
    }
  }
}
