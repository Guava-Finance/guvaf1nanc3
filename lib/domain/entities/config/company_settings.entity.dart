// Entity for company settings
import 'package:equatable/equatable.dart';

class CompanySettingsEntity extends Equatable {
  final String companyWalletAddress;

  const CompanySettingsEntity({
    required this.companyWalletAddress,
  });

  @override
  List<Object?> get props => [companyWalletAddress];
}