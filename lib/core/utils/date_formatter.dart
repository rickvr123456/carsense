import 'package:intl/intl.dart';

/// Date and time formatting utilities
class DateFormatter {
  DateFormatter._();

  static final DateFormat _shortDate = DateFormat('dd/MM/yyyy');
  static final DateFormat _shortDateTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _longDateTime = DateFormat('dd MMMM yyyy HH:mm', 'it_IT');
  static final DateFormat _timeOnly = DateFormat('HH:mm');

  /// Format date as dd/MM/yyyy
  static String formatShortDate(DateTime date) => _shortDate.format(date);

  /// Format date as dd/MM/yyyy HH:mm
  static String formatShortDateTime(DateTime date) => _shortDateTime.format(date);

  /// Format date as dd MMMM yyyy HH:mm
  static String formatLongDateTime(DateTime date) => _longDateTime.format(date);

  /// Format time as HH:mm
  static String formatTime(DateTime date) => _timeOnly.format(date);

  /// Parse ISO8601 string to DateTime
  static DateTime? parseIso8601(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time string (e.g., "2 ore fa", "ieri")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'pochi secondi fa';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minuti fa';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ore fa';
    } else if (difference.inDays == 1) {
      return 'ieri';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} giorni fa';
    } else {
      return formatShortDate(date);
    }
  }
}
