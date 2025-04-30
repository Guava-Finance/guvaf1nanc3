import 'package:guava/features/transfer/domain/entities/recent_wallet_transfer.dart';

class RecentTransferWalletModel extends RecentWalletTransfer {
  const RecentTransferWalletModel({
    required super.address,
    required super.username,
    required super.lastTransferAt,
  });

  factory RecentTransferWalletModel.fromJson(Map<String, dynamic> json) {
    return RecentTransferWalletModel(
      address: json['address'] ?? '',
      username: json['username'] ?? '',
      lastTransferAt: DateTime.parse(json['last_transfer_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'username': username,
      'last_transfer_at': lastTransferAt.toIso8601String(),
    };
  }

  RecentTransferWalletModel copyWith({
    String? address,
    String? username,
    DateTime? lastTransferAt,
  }) {
    return RecentTransferWalletModel(
      address: address ?? this.address,
      username: username ?? this.username,
      lastTransferAt: lastTransferAt ?? this.lastTransferAt,
    );
  }

  static List<RecentWalletTransfer> toList(List<dynamic> data) {
    return data.map((e) => RecentTransferWalletModel.fromJson(e)).toList();
  }
}
