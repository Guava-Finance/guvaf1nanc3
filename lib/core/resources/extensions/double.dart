import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String get formatDecimal {
    return '.${toStringAsFixed(2).substring(toString().indexOf('.') + 1)}';
  }

  String formatAmount({bool round = true}) {
    String amt = toString().split('.')[0];

    return NumberFormat('#,##0', 'en_US').format(int.parse(amt));
  }
}
