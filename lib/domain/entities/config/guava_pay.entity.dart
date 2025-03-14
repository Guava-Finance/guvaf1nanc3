// Entity for Guava Pay settings
import 'package:equatable/equatable.dart';
import 'package:guava/domain/entities/config/country.entity.dart';

class GuavaPayEntity extends Equatable {
  final List<String> businessWalletDerivativePaths;
  final List<CountryEntity> countries;

  const GuavaPayEntity({
    required this.businessWalletDerivativePaths,
    required this.countries,
  });

  @override
  List<Object?> get props => [businessWalletDerivativePaths, countries];
}