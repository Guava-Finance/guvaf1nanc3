import 'package:equatable/equatable.dart';

class IpInfoEntity extends Equatable {
  final String ip;
  final String city;
  final String region;
  final String country;
  final String loc;
  final String org;
  final String postal;
  final String timezone;
  final String readme;

  const IpInfoEntity({
    required this.ip,
    required this.city,
    required this.region,
    required this.country,
    required this.loc,
    required this.org,
    required this.postal,
    required this.timezone,
    required this.readme,
  });

  @override
  List<Object?> get props => [
        ip,
        city,
        region,
        country,
        loc,
        org,
        postal,
        timezone,
        readme,
      ];
}
