import 'package:equatable/equatable.dart';

class Bank extends Equatable {
  final String name;
  final String slug;
  final String code;
  final String country;
  final String nibssBankCode;

  const Bank({
    required this.name,
    required this.slug,
    required this.code,
    required this.country,
    required this.nibssBankCode,
  });

  // Properties used by Equatable to determine equality
  @override
  List<Object?> get props => [name, slug, code, country, nibssBankCode];
}
