/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'CarSense';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration locationTimeout = Duration(seconds: 10);

  // Map Configuration
  static const double defaultMapZoom = 13.0;
  static const double mechanicsSearchRadius = 20000; // meters

  // AI Configuration
  static const String defaultAiModel = 'gemini-2.5-flash';
  static const int maxChatMessages = 100;

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
