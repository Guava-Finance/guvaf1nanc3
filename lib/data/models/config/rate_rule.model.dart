
import 'package:guava/domain/entities/config/rate_rule.entity.dart';

class RateRuleModel extends RateRuleEntity {
  const RateRuleModel({
    required super.min,
    required super.max,
    required super.percentageCharge,
    required super.cappedAmount,
    required super.isCapped,
    required super.rule,
    required super.isUsdc,
  });

  factory RateRuleModel.fromJson(Map<String, dynamic> json) {
    return RateRuleModel(
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
      percentageCharge: json['percentage_charge'].toDouble(),
      cappedAmount: json['capped_amount'].toDouble(),
      isCapped: json['is_capped'],
      rule: json['rule'],
      isUsdc: json['is_usdc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'percentage_charge': percentageCharge,
      'capped_amount': cappedAmount,
      'is_capped': isCapped,
      'rule': rule,
      'is_usdc': isUsdc,
    };
  }

  RateRuleModel copyWith({
    double? min,
    double? max,
    double? percentageCharge,
    double? cappedAmount,
    bool? isCapped,
    String? rule,
    bool? isUsdc,
  }) {
    return RateRuleModel(
      min: min ?? this.min,
      max: max ?? this.max,
      percentageCharge: percentageCharge ?? this.percentageCharge,
      cappedAmount: cappedAmount ?? this.cappedAmount,
      isCapped: isCapped ?? this.isCapped,
      rule: rule ?? this.rule,
      isUsdc: isUsdc ?? this.isUsdc,
    );
  }
}