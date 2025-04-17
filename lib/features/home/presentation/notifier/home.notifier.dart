import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home.notifier.g.dart';

final isBalanceVisibleProvider = StateProvider<bool>((ref) {
  return false;
});

@riverpod
class HomeNotifier extends _$HomeNotifier with ChangeNotifier {
  @override
  HomeNotifier build() {
    return this;
  }
}
