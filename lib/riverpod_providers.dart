import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/gemini_service.dart';
import 'services/ai_chat_service.dart';
import 'services/places_service.dart';
import 'app_state.dart';

// Global logger instance accessible by services (alternative to getIt)
final globalLogger = Logger();

final loggerProvider = Provider<Logger>((ref) {
  return globalLogger;
});

final geminiKeyProvider = Provider<String>((ref) => dotenv.env['GEMINI_API_KEY'] ?? '');
final aiKeyProvider = Provider<String>((ref) => dotenv.env['AI_API_KEY'] ?? dotenv.env['GEMINI_API_KEY'] ?? '');
final placesKeyProvider = Provider<String>((ref) => dotenv.env['PLACES_API_KEY'] ?? '');

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final key = ref.watch(geminiKeyProvider);
  return GeminiService(apiKey: key);
});

final aiChatServiceProvider = ChangeNotifierProvider<AiChatService>((ref) {
  final key = ref.watch(aiKeyProvider);
  return AiChatService(apiKey: key);
});

final placesServiceProvider = Provider<PlacesService>((ref) {
  final key = ref.watch(placesKeyProvider);
  return PlacesService(key);
});

final appStateProvider = ChangeNotifierProvider<AppState>((ref) {
  final state = AppState();
  // attach Gemini when created
  final gemini = ref.read(geminiServiceProvider);
  state.dashboard.attachGemini(gemini);
  return state;
});

// Provider for navigation index in AppShell
final navigationIndexProvider = StateProvider<int>((ref) => 0);

// Provider for AI initial prompt (used when navigating from problems page)
final aiInitialPromptProvider = StateProvider<String?>((ref) => null);
