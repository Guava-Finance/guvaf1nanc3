import 'package:equatable/equatable.dart';
import 'package:guava/features/onboarding/data/models/settings.dart';

class MyAccount extends Equatable {
  final String walletAddress;
  final String accountLevel;
  final double monthlyLimit;
  final Map<String, dynamic> deviceInfo;
  final String ipAddress;
  final SettingsModel settings;

  const MyAccount({
    required this.walletAddress,
    required this.accountLevel,
    required this.monthlyLimit,
    required this.deviceInfo,
    required this.ipAddress,
    required this.settings,
  });

  @override
  List<Object?> get props => [
        walletAddress,
        accountLevel,
        monthlyLimit,
        deviceInfo,
        ipAddress,
        settings,
      ];
}
