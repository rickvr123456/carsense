/// Example usage of DateFormatter
/// 
/// ```dart
/// import 'package:carsense/core/utils/date_formatter.dart';
/// 
/// // Format current date
/// final now = DateTime.now();
/// print(DateFormatter.formatShortDate(now)); // 27/10/2025
/// print(DateFormatter.formatShortDateTime(now)); // 27/10/2025 14:30
/// 
/// // Parse ISO8601 string
/// final date = DateFormatter.parseIso8601('2025-10-27T14:30:00.000Z');
/// 
/// // Get relative time
/// final yesterday = DateTime.now().subtract(Duration(days: 1));
/// print(DateFormatter.getRelativeTime(yesterday)); // "ieri"
/// 
/// final twoHoursAgo = DateTime.now().subtract(Duration(hours: 2));
/// print(DateFormatter.getRelativeTime(twoHoursAgo)); // "2 ore fa"
/// ```

library;
