class AppConstants {
  AppConstants._();

  static const Duration networkTimeout = Duration(seconds: 30);

  static const double defaultMapZoom = 13.0;
  static const double mechanicsSearchRadius = 20000;

  static const int maxDtcCount = 4;
  static const List<String> dtcTypes = ['P', 'B', 'C', 'U'];

  static const String errorHistoryKey = 'obd_errors';

  static const String envGeminiKey = 'GEMINI_API_KEY';
  static const String envPlacesKey = 'PLACES_API_KEY';
}
