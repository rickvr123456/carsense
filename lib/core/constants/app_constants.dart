/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Network Configuration
  static const Duration networkTimeout = Duration(seconds: 30);

  // Map Configuration
  static const double defaultMapZoom = 13.0;
  static const double mechanicsSearchRadius = 20000; // meters

  // DTC Configuration
  static const int maxDtcCount = 4;
  static const List<String> dtcTypes = ['P', 'B', 'C', 'U'];

  // Storage Keys
  static const String errorHistoryKey = 'obd_errors';

  // Environment Variables
  static const String envGeminiKey = 'GEMINI_API_KEY';
  static const String envAiKey = 'AI_API_KEY';
  static const String envPlacesKey = 'PLACES_API_KEY';
}
