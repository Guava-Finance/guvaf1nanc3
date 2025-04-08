// Entity for rates (off_ramp, on_ramp, wallet_transfer)
import 'package:equatable/equatable.dart';
import 'package:guava/features/onboarding/domain/entities/config/rate_rule.entity.dart';

class RatesEntity extends Equatable {
  final List<RateRuleEntity> offRamp;
  final List<RateRuleEntity> onRamp;
  final List<RateRuleEntity> walletTransfer;

  const RatesEntity({
    required this.offRamp,
    required this.onRamp,
    required this.walletTransfer,
  });

  @override
  List<Object?> get props => [offRamp, onRamp, walletTransfer];
}
