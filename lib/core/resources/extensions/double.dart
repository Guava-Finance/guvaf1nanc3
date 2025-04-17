import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String get formatDecimal {
    return '.${toStringAsFixed(2).substring(toString().indexOf('.') + 1)}';
  }

  String formatAmount({bool round = true}) {
    NumberFormat f;

    if (round) {
      f = NumberFormat('#,##0', 'en_US');
    } else {
      f = NumberFormat('#,##0.00', 'en_US');
    }

    return f.format(this);
  }
}
