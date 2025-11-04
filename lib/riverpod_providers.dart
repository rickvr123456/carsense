import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/ai_chat_service.dart';
import 'services/gemini_service.dart';
import 'services/places_service.dart';
import 'core/constants/app_constants.dart';
import 'app_state.dart';

final globalLogger = Logger();

final loggerProvider = Provider<Logger>((ref) {
  return globalLogger;
});

final aiKeyProvider = Provider<String>(
    (ref) {
      final key = dotenv.env[AppConstants.envAiKey] ?? dotenv.env[AppConstants.envGeminiKey] ?? '';
      if (key.isEmpty) {
        globalLogger.w('[Providers] AI keys not configured in .env');
      }
      return key;
    });
final placesKeyProvider =
    Provider<String>((ref) {
      final key = dotenv.env[AppConstants.envPlacesKey] ?? '';
      if (key.isEmpty) {
        globalLogger.w('[Providers] PLACES_API_KEY not configured in .env');
      }
      return key;
    });

final aiChatServiceProvider = ChangeNotifierProvider<AiChatService>((ref) {
  final key = ref.watch(aiKeyProvider);
  return AiChatService(apiKey: key);
});

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final key = ref.watch(aiKeyProvider);
  return GeminiService(apiKey: key);
});

final placesServiceProvider = Provider<PlacesService>((ref) {
  final key = ref.watch(placesKeyProvider);
  return PlacesService(key);
});

final appStateProvider = ChangeNotifierProvider<AppState>((ref) {
  return AppState();
});

final navigationIndexProvider = StateProvider<int>((ref) => 0);

final aiInitialPromptProvider = StateProvider<String?>((ref) => null);

final problemsSelectionModeProvider = StateProvider<bool>((ref) => false);
final problemsSelectedDtcsProvider = StateProvider<Set<String>>((ref) => {});
final problemsExpandedListProvider = StateProvider<Map<String, bool>>((ref) => {});
