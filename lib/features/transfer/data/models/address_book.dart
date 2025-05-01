import 'package:guava/features/transfer/domain/entities/address_book.dart';

class WalletAddressBookModel extends WalletAddressBook {
  const WalletAddressBookModel({
    required super.id,
    required super.address,
    required super.username,
    required super.label,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WalletAddressBookModel.fromJson(Map<String, dynamic> json) {
    return WalletAddressBookModel(
      id: json['id'],
      address: json['address'],
      username: json['username'],
      label: json['label'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'username': username,
      'label': label,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WalletAddressBookModel copyWith({
    String? id,
    String? address,
    String? username,
    String? label,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletAddressBookModel(
      id: id ?? this.id,
      address: address ?? this.address,
      username: username ?? this.username,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static List<WalletAddressBook> toList(List<dynamic> data) {
    return data.map((e) => WalletAddressBookModel.fromJson(e)).toList();
  }
}
