extension DoubleExtension on double {
  /// Returns only the decimal part of a double as a double.
  ///
  /// Example:
  /// - 3.142 returns 0.142
  /// - 5.0 returns 0.0
  /// - -7.25 returns 0.25 (ignores the sign)
  String get decimalPart {
    // Take the absolute value to handle negative numbers properly
    final absoluteValue = abs();

    // Get the integer part
    final integerPart = absoluteValue.toInt();

    // Subtract the integer part to get just the decimal part
    return (absoluteValue - integerPart)
        .toStringAsFixed(2)
        .replaceFirst('0', '');
  }
}
