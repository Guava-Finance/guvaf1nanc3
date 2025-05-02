import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/features/receive/presentation/notifier/recieve.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recieve.notifier.g.dart';

final activeReceiveTabState = StateProvider<int>((ref) {
  return 0;
});

@riverpod
class RecieveNotifier extends _$RecieveNotifier {
  @override
  RecieveState build() {
    pageController = PageController(
      initialPage: ref.watch(activeReceiveTabState),
    );

    ref.onDispose(() => pageController.dispose());
    return const RecieveState();
  }

  late PageController pageController;

  void jumpTo(int page) {
    pageController.jumpToPage(page);
    ref.watch(activeReceiveTabState.notifier).state = page;
  }
}
