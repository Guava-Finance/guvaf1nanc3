import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final String kycStatus;

  const Settings({
    required this.kycStatus,
  });

  @override
  List<Object?> get props => [
        kycStatus,
      ];
}
