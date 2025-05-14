// Entity for country details
import 'package:equatable/equatable.dart';
import 'package:guava/features/onboarding/domain/entities/config/rate.entity.dart';

class CountryEntity extends Equatable {
  final String name;
  final String countryCode;
  final String currency;
  final String currencyCode;
  final String currencySymbol;
  final String callingCode;
  final List<int> phoneLength;
  final List<String>? kycPartners;
  final List<String>? kybPartners;
  final RatesEntity rates;
  final int? bankAccountLenght;
  final bool isWalletTransferEnabled;
  final bool isOnRampEnabled;
  final bool isOffRampEnabled;
  final bool isKycEnabled;

  const CountryEntity({
    required this.name,
    required this.countryCode,
    required this.currency,
    required this.currencyCode,
    required this.currencySymbol,
    required this.callingCode,
    required this.phoneLength,
    required this.kycPartners,
    required this.kybPartners,
    required this.rates,
    required this.bankAccountLenght,
    required this.isWalletTransferEnabled,
    required this.isOnRampEnabled,
    required this.isOffRampEnabled,
    required this.isKycEnabled,
  });

  @override
  List<Object?> get props => [
        name,
        countryCode,
        currency,
        currencyCode,
        currencySymbol,
        callingCode,
        phoneLength,
        kycPartners,
        rates,
        isKycEnabled,
        isOffRampEnabled,
        isOnRampEnabled,
        isWalletTransferEnabled,
        bankAccountLenght,
      ];
}
