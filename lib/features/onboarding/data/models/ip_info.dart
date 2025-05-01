import 'package:guava/features/onboarding/domain/entities/ip_info.dart';

class IpInfo extends IpInfoEntity {
  const IpInfo({
    required super.ip,
    required super.city,
    required super.region,
    required super.country,
    required super.loc,
    required super.org,
    required super.postal,
    required super.timezone,
    required super.readme,
  });

  factory IpInfo.fromJson(Map<String, dynamic> json) {
    return IpInfo(
      ip: json['ip'] ?? '',
      city: json['city'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? '',
      loc: json['loc'] ?? '',
      org: json['org'] ?? '',
      postal: json['postal'] ?? '',
      timezone: json['timezone'] ?? '',
      readme: json['readme'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'city': city,
      'region': region,
      'country': country,
      'loc': loc,
      'org': org,
      'postal': postal,
      'timezone': timezone,
      'readme': readme,
    };
  }

  IpInfo copyWith({
    String? ip,
    String? city,
    String? region,
    String? country,
    String? loc,
    String? org,
    String? postal,
    String? timezone,
    String? readme,
  }) {
    return IpInfo(
      ip: ip ?? this.ip,
      city: city ?? this.city,
      region: region ?? this.region,
      country: country ?? this.country,
      loc: loc ?? this.loc,
      org: org ?? this.org,
      postal: postal ?? this.postal,
      timezone: timezone ?? this.timezone,
      readme: readme ?? this.readme,
    );
  }
}
