import 'package:collection/collection.dart';
import 'package:guava/features/home/domain/entities/transaction_history.dart';
import 'package:intl/intl.dart';

extension TxnsExtensions on List<TransactionsHistory> {
  Map<String, List<TransactionsHistory>> get groupedbyDate {
    final group = groupBy(
      this,
      (e) => DateFormat.yMMMEd().format(
        DateTime(
          (e.timestamp ?? DateTime.now()).year,
          (e.timestamp ?? DateTime.now()).month,
          (e.timestamp ?? DateTime.now()).day,
        ),
      ),
    );

    return group;
  }
}
