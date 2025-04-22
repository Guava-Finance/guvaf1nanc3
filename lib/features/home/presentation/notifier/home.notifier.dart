import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home.notifier.g.dart';

final isBalanceVisibleProvider = StateProvider<bool>((ref) {
  return false;
});

final avatarProvider = FutureProvider<String>((ref) async {
  final wallet = await ref.watch(solanaServiceProvider).walletAddress();

  return wallet.avatar;
});

@riverpod
class HomeNotifier extends _$HomeNotifier with ChangeNotifier {
  @override
  HomeNotifier build() {
    return this;
  }
}
