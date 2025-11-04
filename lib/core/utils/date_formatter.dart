import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _shortDateTime = DateFormat('dd/MM/yyyy HH:mm');

  static String formatShortDateTime(DateTime date) =>
      _shortDateTime.format(date);

  static DateTime? parseIso8601(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
