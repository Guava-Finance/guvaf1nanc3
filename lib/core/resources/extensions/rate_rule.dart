import 'package:guava/features/onboarding/domain/entities/config/rate_rule.entity.dart';

extension RateRuleExt on List<RateRuleEntity> {
  double calculateTransactionFee(double amount) {
    for (final rule in this) {
      final isBetween =
          rule.rule == 'between' && amount >= rule.min && amount <= rule.max;
      final isAbove = rule.rule == 'above' && amount > rule.min;

      if (isBetween || isAbove) {
        double fee = (amount * rule.percentageCharge) / 100;
        return rule.isCapped ? fee.clamp(0, rule.cappedAmount) : fee;
      }
    }

    throw Exception('No applicable fee rule for amount: $amount');
  }
}
