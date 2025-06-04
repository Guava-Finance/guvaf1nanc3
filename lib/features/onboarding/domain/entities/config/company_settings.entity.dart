// Entity for company settings
import 'package:equatable/equatable.dart';

class CompanySettingsEntity extends Equatable {
  final String companyWalletAddress;
  final String companFeeyWalletAddress;

  const CompanySettingsEntity({
    required this.companyWalletAddress,
    required this.companFeeyWalletAddress,
  });

  @override
  List<Object?> get props => [companyWalletAddress];
}