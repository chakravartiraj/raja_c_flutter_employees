class DateFormatter {
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Formats a DateTime to a readable string format (e.g., "15 Jan 2024")
  static String formatDate(DateTime date) =>
      '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

  /// Gets the month name for a given month number (1-12)
  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return _monthNames[month - 1];
  }

  /// Formats a date range string (e.g., "15 Jan 2024 - Present" or "15 Jan 2024 - 20 Dec 2024")
  static String formatDateRange(DateTime startDate, DateTime? endDate) {
    final startFormatted = formatDate(startDate);
    final endFormatted = endDate != null ? formatDate(endDate) : 'Present';
    return '$startFormatted - $endFormatted';
  }

  /// Formats a DateTime to a short format (e.g., "15/01/2024")
  static String formatDateShort(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  /// Formats a DateTime to ISO format (e.g., "2024-01-15")
  static String formatDateISO(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
