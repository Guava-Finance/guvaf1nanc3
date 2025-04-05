// Main entity for the entire JSON
import 'package:equatable/equatable.dart';
import 'package:guava/features/onboarding/domain/entities/config/company_settings.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/country.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/guava_pay.entity.dart';
import 'package:guava/features/onboarding/domain/entities/config/wallet_settings.entity.dart';

class AppConfigEntity extends Equatable {
  final String appName;
  final WalletSettingsEntity walletSettings;
  final CompanySettingsEntity companySettings;
  final GuavaPayEntity guavaPay;
  final List<CountryEntity> countries;

  const AppConfigEntity({
    required this.appName,
    required this.walletSettings,
    required this.companySettings,
    required this.guavaPay,
    required this.countries,
  });

  @override
  List<Object?> get props => [
        appName,
        walletSettings,
        companySettings,
        guavaPay,
        countries,
      ];
}