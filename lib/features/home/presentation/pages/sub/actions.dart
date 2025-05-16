import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';

class ActionTasks extends ConsumerStatefulWidget {
  const ActionTasks({
    super.key,
  });

  @override
  ConsumerState<ActionTasks> createState() => _ActionTasksState();
}

class _ActionTasksState extends ConsumerState<ActionTasks> {
  late final PageController controller;

  Timer? _autoScrollTimer;
  final bool _isForward = true;

  @override
  initState() {
    controller = PageController(viewportFraction: 0.9);
    super.initState();

    // Start auto-scrolling with a delay to allow UI to build
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  // int totalLength = 0;

  // void _startAutoScroll() {
  //   setState(() {});

  //   // Set a timer that triggers every 3 seconds
  //   _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
  //     if (!mounted) return;

  //     int ca = ref.read(currentAction);

  //     if (_isForward) {
  //       // Moving forward
  //       if (ca < totalLength - 1) {
  //         controller.animateToPage(
  //           ca + 1,
  //           duration: Durations.long2,
  //           curve: Curves.linear,
  //         );
  //       } else {
  //         // Reached the end, change direction
  //         _isForward = false;
  //         controller.animateToPage(
  //           ca - 1,
  //           duration: Durations.long2,
  //           curve: Curves.linear,
  //         );
  //       }
  //     } else {
  //       // Moving backward
  //       if (ca > 0) {
  //         controller.animateToPage(
  //           ca - 1,
  //           duration: Durations.long2,
  //           curve: Curves.linear,
  //         );
  //       } else {
  //         // Reached the beginning, change direction
  //         _isForward = true;
  //         controller.animateToPage(
  //           ca + 1,
  //           duration: Durations.long2,
  //           curve: Curves.linear,
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final actions = ref.watch(pendingActions);

        return actions.when(
          data: (data) {
            return SizedBox(
              height: 90.h,
              child: PageView(
                onPageChanged: (value) {
                  ref.read(currentAction.notifier).state = value;
                },
                controller: controller,
                children: data,
              ),
            );
          },
          error: (_, __) {
            return 0.verticalSpace;
          },
          loading: () {
            return 0.verticalSpace;
          },
        );
      },
    );
  }
}
