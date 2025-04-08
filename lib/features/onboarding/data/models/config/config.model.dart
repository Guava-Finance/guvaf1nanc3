

import 'package:guava/features/onboarding/data/models/config/company_settings.model.dart';
import 'package:guava/features/onboarding/data/models/config/country.model.dart';
import 'package:guava/features/onboarding/data/models/config/guava_pay.model.dart';
import 'package:guava/features/onboarding/data/models/config/wallet_settings.model.dart';
import 'package:guava/features/onboarding/domain/entities/config/company_settings.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/config.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/guava_pay.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/wallet_settings.entity.dart';

class AppConfigModel extends AppConfigEntity {
  const AppConfigModel({
    required super.appName,
    required super.walletSettings,
    required super.companySettings,
    required super.guavaPay,
    required super.countries,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      appName: json['app_name'],
      walletSettings: WalletSettingsModel.fromJson(json['wallet_settings']),
      companySettings: CompanySettingsModel.fromJson(json['company_settings']),
      guavaPay: GuavaPayModel.fromJson(json['guava_pay']),
      countries: (json['countries'] as List)
          .map((e) => CountryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'wallet_settings': (walletSettings as WalletSettingsModel).toJson(),
      'company_settings': (companySettings as CompanySettingsModel).toJson(),
      'guava_pay': (guavaPay as GuavaPayModel).toJson(),
      'countries': countries.map((e) => (e as CountryModel).toJson()).toList(),
    };
  }

  AppConfigModel copyWith({
    String? appName,
    WalletSettingsEntity? walletSettings,
    CompanySettingsEntity? companySettings,
    GuavaPayEntity? guavaPay,
    List<CountryEntity>? countries,
  }) {
    return AppConfigModel(
      appName: appName ?? this.appName,
      walletSettings: walletSettings ?? this.walletSettings,
      companySettings: companySettings ?? this.companySettings,
      guavaPay: guavaPay ?? this.guavaPay,
      countries: countries ?? this.countries,
    );
  }
}