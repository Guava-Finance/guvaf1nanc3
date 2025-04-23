import 'package:flutter/widgets.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfer.notifier.g.dart';

@riverpod
class TransferNotifier extends _$TransferNotifier {
  @override
  TransferState build() {
    pageController = PageController();
    ref.onDispose(() => pageController.dispose());
    return const TransferState();
  }

  late PageController pageController;

  void updateTransferType(String type) {
    state = state.copyWith(selectedTransferType: type);

    if (type.toLowerCase().contains('wallet')) {
      pageController.jumpToPage(0);
      state = state.copyWith(currentPage: 0);
    } else if (type.toLowerCase().contains('bank')) {
      pageController.jumpToPage(1);
      state = state.copyWith(currentPage: 1);
    }
  }

  void forward() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  void backward() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  void jumpTo(int page) {
    pageController.jumpToPage(page);
    state = state.copyWith(currentPage: page);
  }
}
