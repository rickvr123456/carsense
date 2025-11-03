import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'gemini_service.dart';

/// Singleton globale per GeminiService
GeminiService? _geminiInstance;

GeminiService? get geminiInstance {
  // Lazy initialization on first access
  if (_geminiInstance == null) {
    _initializeGemini();
  }
  return _geminiInstance;
}

void _initializeGemini() {
  try {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _geminiInstance = GeminiService(apiKey: apiKey);
  } catch (e) {
    _geminiInstance = null;
  }
}
