import 'package:guava/features/onboarding/domain/entities/config/company_settings.entity.dart';

class CompanySettingsModel extends CompanySettingsEntity {
  const CompanySettingsModel({
    required super.companyWalletAddress,
    required super.companFeeyWalletAddress,
  });

  factory CompanySettingsModel.fromJson(Map<String, dynamic> json) {
    return CompanySettingsModel(
      companyWalletAddress: json['company_wallet_address'],
      companFeeyWalletAddress: json['company_fee_wallet_address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_wallet_address': companyWalletAddress,
      'company_fee_wallet_address': companFeeyWalletAddress,
    };
  }

  CompanySettingsModel copyWith({
    String? companyWalletAddress,
    String? companFeeyWalletAddress,
  }) {
    return CompanySettingsModel(
      companyWalletAddress: companyWalletAddress ?? this.companyWalletAddress,
      companFeeyWalletAddress:
          companFeeyWalletAddress ?? this.companFeeyWalletAddress,
    );
  }
}
