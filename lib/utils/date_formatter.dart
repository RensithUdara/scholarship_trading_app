import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// Format date in a human-readable format (e.g., "Jan 15, 2024")
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format date with time (e.g., "Jan 15, 2024 14:30")
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Format date in short format (e.g., "15/01/2024")
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format time only (e.g., "14:30")
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Get relative time string (e.g., "2 days ago", "in 3 hours")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Tomorrow';
      } else if (difference.inDays < 7) {
        return 'In ${difference.inDays} days';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? 'In 1 week' : 'In $weeks weeks';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? 'In 1 month' : 'In $months months';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? 'In 1 year' : 'In $years years';
      }
    } else if (difference.inDays < 0) {
      final absDays = difference.inDays.abs();
      if (absDays == 1) {
        return 'Yesterday';
      } else if (absDays < 7) {
        return '$absDays days ago';
      } else if (absDays < 30) {
        final weeks = (absDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (absDays < 365) {
        final months = (absDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      } else {
        final years = (absDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      }
    } else {
      // Same day
      if (difference.inHours > 0) {
        return difference.inHours == 1 ? 'In 1 hour' : 'In ${difference.inHours} hours';
      } else if (difference.inHours < 0) {
        final absHours = difference.inHours.abs();
        return absHours == 1 ? '1 hour ago' : '$absHours hours ago';
      } else if (difference.inMinutes > 0) {
        return difference.inMinutes == 1 ? 'In 1 minute' : 'In ${difference.inMinutes} minutes';
      } else if (difference.inMinutes < 0) {
        final absMinutes = difference.inMinutes.abs();
        return absMinutes == 1 ? '1 minute ago' : '$absMinutes minutes ago';
      } else {
        return 'Now';
      }
    }
  }

  /// Get time until deadline with color coding context
  static String getDeadlineText(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    
    if (difference.inDays < 0) {
      return 'Deadline passed';
    } else if (difference.inDays == 0) {
      if (difference.inHours > 0) {
        return 'Deadline in ${difference.inHours}h';
      } else {
        return 'Deadline soon!';
      }
    } else if (difference.inDays == 1) {
      return 'Deadline tomorrow';
    } else if (difference.inDays <= 7) {
      return 'Deadline in ${difference.inDays} days';
    } else if (difference.inDays <= 30) {
      final weeks = (difference.inDays / 7).ceil();
      return weeks == 1 ? 'Deadline in 1 week' : 'Deadline in $weeks weeks';
    } else {
      return 'Deadline ${formatDate(deadline)}';
    }
  }

  /// Check if deadline is urgent (within 7 days)
  static bool isDeadlineUrgent(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return difference.inDays <= 7 && difference.inDays >= 0;
  }

  /// Check if deadline has passed
  static bool isDeadlinePassed(DateTime deadline) {
    return deadline.isBefore(DateTime.now());
  }
}
