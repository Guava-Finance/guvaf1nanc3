import 'package:flutter/widgets.dart';
import 'package:guava/features/receive/presentation/notifier/recieve.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recieve.notifier.g.dart';

@riverpod
class RecieveNotifier extends _$RecieveNotifier {
  @override
  RecieveState build() {
    pageController = PageController();
    ref.onDispose(() => pageController.dispose());
    return const RecieveState();
  }

  late PageController pageController;

  void updateRecieveType(String type) {
    state = state.copyWith(selectedRecieveType: type);

    if (type == 'Code') {
      pageController.jumpToPage(0); 
      state = state.copyWith(currentPage: 0);
    } else if (type == 'Bank') {
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
