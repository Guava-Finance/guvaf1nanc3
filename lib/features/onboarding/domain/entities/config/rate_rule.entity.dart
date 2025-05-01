import 'package:equatable/equatable.dart';

class RateRuleEntity extends Equatable {
  final double min;
  final double max;
  final double percentageCharge;
  final double cappedAmount;
  final bool isCapped;
  final String rule;
  final bool isUsdc;

  const RateRuleEntity({
    required this.min,
    required this.max,
    required this.percentageCharge,
    required this.cappedAmount,
    required this.isCapped,
    required this.rule,
    required this.isUsdc,
  });

  @override
  List<Object?> get props => [
        min,
        max,
        percentageCharge,
        cappedAmount,
        isCapped,
        rule,
        isUsdc,
      ];
}
