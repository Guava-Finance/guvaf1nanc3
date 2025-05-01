
import 'package:guava/features/onboarding/domain/entities/config/company_settings.entity.dart';

class CompanySettingsModel extends CompanySettingsEntity {
  const CompanySettingsModel({
    required super.companyWalletAddress,
  });

  factory CompanySettingsModel.fromJson(Map<String, dynamic> json) {
    return CompanySettingsModel(
      companyWalletAddress: json['company_wallet_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_wallet_address': companyWalletAddress,
    };
  }

  CompanySettingsModel copyWith({
    String? companyWalletAddress,
  }) {
    return CompanySettingsModel(
      companyWalletAddress: companyWalletAddress ?? this.companyWalletAddress,
    );
  }
}