import 'package:guava/data/models/config/rate_rule.model.dart';
import 'package:guava/domain/entities/config/rate.entity.dart';
import 'package:guava/domain/entities/config/rate_rule.entity.dart';

class RatesModel extends RatesEntity {
  const RatesModel({
    required super.offRamp,
    required super.onRamp,
    required super.walletTransfer,
  });

  factory RatesModel.fromJson(Map<String, dynamic> json) {
    return RatesModel(
      offRamp: (json['off_ramp'] as List)
          .map((e) => RateRuleModel.fromJson(e))
          .toList(),
      onRamp: (json['on_ramp'] as List)
          .map((e) => RateRuleModel.fromJson(e))
          .toList(),
      walletTransfer: (json['wallet_transfer'] as List)
          .map((e) => RateRuleModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'off_ramp': offRamp.map((e) => (e as RateRuleModel).toJson()).toList(),
      'on_ramp': onRamp.map((e) => (e as RateRuleModel).toJson()).toList(),
      'wallet_transfer':
          walletTransfer.map((e) => (e as RateRuleModel).toJson()).toList(),
    };
  }

  RatesModel copyWith({
    List<RateRuleEntity>? offRamp,
    List<RateRuleEntity>? onRamp,
    List<RateRuleEntity>? walletTransfer,
  }) {
    return RatesModel(
      offRamp: offRamp ?? this.offRamp,
      onRamp: onRamp ?? this.onRamp,
      walletTransfer: walletTransfer ?? this.walletTransfer,
    );
  }
}

