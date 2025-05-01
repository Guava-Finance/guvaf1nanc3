// Entity for wallet settings
import 'package:equatable/equatable.dart';

class WalletSettingsEntity extends Equatable {
  final String derivativePath;
  final String usdcMintAddress;

  const WalletSettingsEntity({
    required this.derivativePath,
    required this.usdcMintAddress,
  });

  @override
  List<Object?> get props => [derivativePath, usdcMintAddress];
}