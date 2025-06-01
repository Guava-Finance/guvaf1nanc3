import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/notification/wrapper/notification.wrapper.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';

class BlurWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const BlurWrapper({
    required this.child,
    super.key,
  });

  @override
  BlurWrapperState createState() => BlurWrapperState();
}

class BlurWrapperState extends ConsumerState<BlurWrapper> {
  bool shouldBlur = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // this disposes keyboard on tap of anywhere outside keyboard or textfield
    return GestureDetector(
      onTap: () {
        navkey.currentContext!.focusScope.unfocus();
      },
      child: Consumer(
        builder: (context, ref, child) {
          return Stack(
            children: [
              InAppNotificationWrapper(child: widget.child),
              if (shouldBlur) ...{
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    height: double.maxFinite,
                    width: double.infinity,
                    color: BrandColors.backgroundColor.withValues(alpha: .8),
                  ),
                ),
              },
            ],
          );
        },
      ),
    );
  }
}
