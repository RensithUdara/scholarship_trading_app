import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_AU', // Australian locale
    symbol: '\$',
    decimalDigits: 0, // No decimal places for whole numbers
  );

  static final NumberFormat _preciseFormat = NumberFormat.currency(
    locale: 'en_AU',
    symbol: '\$',
    decimalDigits: 2, // Show decimal places
  );

  static final NumberFormat _compactFormat = NumberFormat.compactCurrency(
    locale: 'en_AU',
    symbol: '\$',
    decimalDigits: 0,
  );

  /// Format currency with no decimals for whole numbers
  /// e.g., $1,500 or $1,500.50
  static String format(double amount) {
    if (amount == amount.roundToDouble()) {
      return _currencyFormat.format(amount);
    } else {
      return _preciseFormat.format(amount);
    }
  }

  /// Format currency with forced 2 decimal places
  /// e.g., $1,500.00
  static String formatPrecise(double amount) {
    return _preciseFormat.format(amount);
  }

  /// Format currency in compact form
  /// e.g., $1.5K, $2.3M
  static String formatCompact(double amount) {
    return _compactFormat.format(amount);
  }

  /// Format currency range
  /// e.g., $1,000 - $5,000
  static String formatRange(double minAmount, double maxAmount) {
    return '${format(minAmount)} - ${format(maxAmount)}';
  }

  /// Format bid amount with context
  static String formatBid(double? currentBid, double? minimumBid, double fixedPrice) {
    if (currentBid != null) {
      return 'Current bid: ${format(currentBid)}';
    } else if (minimumBid != null) {
      return 'Minimum bid: ${format(minimumBid)}';
    } else {
      return 'Price: ${format(fixedPrice)}';
    }
  }

  /// Parse currency string back to double
  /// Handles strings like "$1,500", "$1,500.00", "1500"
  static double? parse(String currencyString) {
    try {
      // Remove currency symbol and thousands separators
      String cleanString = currencyString
          .replaceAll(RegExp(r'[\$,]'), '')
          .trim();
      
      return double.parse(cleanString);
    } catch (e) {
      return null;
    }
  }

  /// Format percentage
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Format savings or discount
  static String formatSavings(double originalPrice, double salePrice) {
    final savings = originalPrice - salePrice;
    final percentage = (savings / originalPrice) * 100;
    return 'Save ${format(savings)} (${formatPercentage(percentage)})';
  }

  /// Check if amount is in a reasonable range
  static bool isValidAmount(double amount) {
    return amount >= 0 && amount <= 100000; // Max $100,000 for scholarships
  }

  /// Format amount with context based on size
  static String formatWithContext(double amount) {
    if (amount >= 10000) {
      return '${formatCompact(amount)} (${format(amount)})';
    } else {
      return format(amount);
    }
  }
}
