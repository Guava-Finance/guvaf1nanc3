import 'package:dart_casing/dart_casing.dart';

extension StringExt on String {
  String get pathToName {
    final name = split('/');

    return '_${name.map((e) => Casing.titleCase(e)).join()}';
  }

  String toMaskedFormat({
    int prefixLength = 3,
    int suffixLength = 4,
    String maskCharacter = '.',
    int maskLength = 4,
  }) {
    // Handle edge cases
    if (isEmpty) return '';

    // If the string is too short to mask properly
    final totalVisibleLength = prefixLength + suffixLength;
    if (length <= totalVisibleLength) {
      return this;
    }

    // Extract prefix and suffix
    final prefix = substring(0, prefixLength);
    final suffix = substring(length - suffixLength);

    // Create mask with specified length and character
    final mask = maskCharacter * maskLength;

    // Combine parts with mask in the middle
    return '$prefix$mask$suffix';
  }

  String get decimalPartString {
    // Get the string representation of the number
    String numStr = toString();

    // Find the decimal point
    int decimalPointIndex = numStr.indexOf('.');

    // If there's no decimal point, return ".0"
    if (decimalPointIndex == -1) {
      return '.0';
    }

    // Return everything from the decimal point onwards
    return numStr.substring(decimalPointIndex);
  }
}
