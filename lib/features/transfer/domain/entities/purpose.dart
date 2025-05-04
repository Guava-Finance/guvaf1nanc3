import 'package:equatable/equatable.dart';

class TransferPurpose extends Equatable {
  final String id;
  final String title;

  const TransferPurpose({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
