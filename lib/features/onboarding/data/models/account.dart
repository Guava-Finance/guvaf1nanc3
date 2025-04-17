import 'dart:convert';

import 'package:guava/features/onboarding/data/models/settings.dart';
import 'package:guava/features/onboarding/domain/entities/account.dart';

class AccountModel extends MyAccount {
  const AccountModel({
    required super.walletAddress,
    required super.accountLevel,
    required super.monthlyLimit,
    required super.deviceInfo,
    required super.ipAddress,
    required super.settings,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      walletAddress: json['wallet_address'] ?? '',
      accountLevel: json['account_level'] ?? '',
      monthlyLimit:
          num.tryParse(json['monthly_limit']?.toString() ?? '')?.toDouble() ??
              0.0,
      deviceInfo: jsonDecode(json['device_info'] ?? ''),
      ipAddress: json['ip_address'] ?? '',
      settings: SettingsModel.fromJson(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_address': walletAddress,
      'account_level': accountLevel,
      'monthly_limit': monthlyLimit.toString(),
      'device_info': jsonEncode(deviceInfo),
      'ip_address': ipAddress,
      'settings': settings.toJson(),
    };
  }

  AccountModel copyWith({
    String? walletAddress,
    String? accountLevel,
    double? monthlyLimit,
    Map<String, dynamic>? deviceInfo,
    String? ipAddress,
    SettingsModel? settings,
  }) {
    return AccountModel(
      walletAddress: walletAddress ?? this.walletAddress,
      accountLevel: accountLevel ?? this.accountLevel,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      ipAddress: ipAddress ?? this.ipAddress,
      settings: settings ?? this.settings,
    );
  }
}
