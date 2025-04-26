import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfer.notifier.g.dart';

final activeTabState = StateProvider<int>((ref) {
  return 0;
});

@riverpod
class TransferNotifier extends _$TransferNotifier {
  @override
  TransferNotifier build() {
    pageController = PageController();
    ref.onDispose(() => pageController.dispose());
    return this;
  }

  late PageController pageController;


  void jumpTo(int page) {
    pageController.jumpToPage(page);
  }

  Future<void> resolveAddress(String address) async {
    await ref.read(resolveAddressUsecaseProvider).call(params: address);
  }
}
