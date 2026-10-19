import 'package:intl/intl.dart';

/// Date range representation for interval calculations.
class DateInterval {
  final DateTime start;
  final DateTime end;

  DateInterval(this.start, this.end) {
    assert(!end.isBefore(start), 'End date cannot be before start date');
  }

  int get totalMonths {
    return ((end.year - start.year) * 12) + (end.month - start.month) + 1;
  }
}

/// Utility for calculating single and cumulative experience durations,
/// correctly merging overlapping time periods to prevent double-counting.
class ExperienceCalculator {
  ExperienceCalculator._();

  static final List<DateFormat> _dateFormats = [
    DateFormat('MMMM yyyy'), // June 2024
    DateFormat('MMM yyyy'), // Jun 2024
    DateFormat('yyyy-MM'), // 2024-06
    DateFormat('yyyy'), // 2024
  ];

  /// Parses date strings such as "June 2024", "Jun 2024", "Present", "Current".
  static DateTime? parseDate(String? dateStr, {bool isEnd = false}) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    final trimmed = dateStr.trim().toLowerCase();

    if (trimmed == 'present' || trimmed == 'current' || trimmed == 'now') {
      return DateTime.now();
    }

    for (final format in _dateFormats) {
      try {
        final parsed = format.parseLoose(dateStr.trim());
        if (isEnd) {
          // If it's an end date, point to the last day of that month
          final nextMonth = DateTime(parsed.year, parsed.month + 1, 1);
          return nextMonth.subtract(const Duration(days: 1));
        }
        return DateTime(parsed.year, parsed.month, 1);
      } catch (_) {
        // Try next format
      }
    }
    return null;
  }

  /// Calculates human-readable duration for a single role.
  static String calculateSingleDuration(
    String startDateStr,
    String endDateStr,
  ) {
    final start = parseDate(startDateStr);
    final end = parseDate(endDateStr, isEnd: true);

    if (start == null || end == null || end.isBefore(start)) {
      return '';
    }

    final totalMonths =
        ((end.year - start.year) * 12) + (end.month - start.month) + 1;
    return formatMonths(totalMonths);
  }

  /// Merges overlapping or contiguous date intervals and calculates total unique experience.
  static String calculateTotalExperience(List<Map<String, String>> ranges) {
    final intervals = <DateInterval>[];

    for (final range in ranges) {
      final start = parseDate(range['start']);
      final end = parseDate(range['end'], isEnd: true);
      if (start != null && end != null && !end.isBefore(start)) {
        intervals.add(DateInterval(start, end));
      }
    }

    if (intervals.isEmpty) return '0 mos';

    // Sort intervals by start date
    intervals.sort((a, b) => a.start.compareTo(b.start));

    // Merge overlapping intervals
    final merged = <DateInterval>[];
    DateInterval current = intervals.first;

    for (int i = 1; i < intervals.length; i++) {
      final next = intervals[i];
      // Check if overlapping or adjacent (within 32 days)
      if (next.start.isBefore(current.end) ||
          next.start.difference(current.end).inDays <= 32) {
        final maxEnd = next.end.isAfter(current.end) ? next.end : current.end;
        current = DateInterval(current.start, maxEnd);
      } else {
        merged.add(current);
        current = next;
      }
    }
    merged.add(current);

    int totalMonths = 0;
    for (final interval in merged) {
      totalMonths += interval.totalMonths;
    }

    return formatMonths(totalMonths);
  }

  /// Formats a month count into a friendly string (e.g. "3 yrs 11 mos").
  static String formatMonths(int totalMonths) {
    if (totalMonths <= 0) return '0 mos';
    final years = totalMonths ~/ 12;
    final months = totalMonths % 12;

    if (years == 0) {
      return '$months ${months == 1 ? "mo" : "mos"}';
    }
    if (months == 0) {
      return '$years ${years == 1 ? "yr" : "yrs"}';
    }
    return '$years ${years == 1 ? "yr" : "yrs"} $months ${months == 1 ? "mo" : "mos"}';
  }
}
