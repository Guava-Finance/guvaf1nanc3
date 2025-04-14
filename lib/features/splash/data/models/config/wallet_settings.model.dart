
import 'package:guava/features/onboarding/domain/entities/config/wallet_settings.entity.dart';

class WalletSettingsModel extends WalletSettingsEntity {
  const WalletSettingsModel({
    required super.derivativePath,
    required super.usdcMintAddress,
  });

  factory WalletSettingsModel.fromJson(Map<String, dynamic> json) {
    return WalletSettingsModel(
      derivativePath: json['derivative_path'],
      usdcMintAddress: json['usdc_mint_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'derivative_path': derivativePath,
      'usdc_mint_address': usdcMintAddress,
    };
  }

  WalletSettingsModel copyWith({
    String? derivativePath,
    String? usdcMintAddress,
  }) {
    return WalletSettingsModel(
      derivativePath: derivativePath ?? this.derivativePath,
      usdcMintAddress: usdcMintAddress ?? this.usdcMintAddress,
    );
  }
}