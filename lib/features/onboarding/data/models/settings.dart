import 'package:guava/features/onboarding/domain/entities/settings.dart';

class SettingsModel extends Settings {
  const SettingsModel({
    required super.kycStatus,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      kycStatus: json['kyc_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kyc_status': kycStatus,
    };
  }

  SettingsModel copyWith({String? kycStatus}) {
    return SettingsModel(
      kycStatus: kycStatus ?? this.kycStatus,
    );
  }
}
