import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String code;
  final String currency;
  final String currencyCode;
  final String currencySymbol;

  const Country({
    required this.name,
    required this.code,
    required this.currency,
    required this.currencyCode,
    required this.currencySymbol,
  });

  // Properties used by Equatable to determine equality
  @override
  List<Object?> get props => [
        name,
        code,
        currency,
        currencyCode,
        currencySymbol,
      ];
}
