import 'package:guava/features/transfer/domain/entities/purpose.dart';

class TransferPurposeModel extends TransferPurpose {
  const TransferPurposeModel({
    required super.id,
    required super.title,
  });

  factory TransferPurposeModel.fromJson(Map<String, dynamic> json) {
    return TransferPurposeModel(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  TransferPurposeModel copyWith({
    String? id,
    String? title,
  }) {
    return TransferPurposeModel(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  static List<TransferPurpose> toList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => TransferPurposeModel.fromJson(
              json as Map<String, dynamic>,
            ))
        .toList();
  }
}
