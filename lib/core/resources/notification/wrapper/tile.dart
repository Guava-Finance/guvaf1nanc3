import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';

enum NotificationType { success, warning, error, information }

Color notificationColor(NotificationType notificationType) {
  return switch (notificationType) {
    NotificationType.success => BrandColors.washedGreen,
    NotificationType.warning => BrandColors.washedYellow,
    NotificationType.information => BrandColors.washedBlue,
    NotificationType.error => BrandColors.washedRed,
  };
}

IconData iconType(NotificationType notificationType) {
  return switch (notificationType) {
    NotificationType.success => Icons.check_circle,
    NotificationType.warning => Icons.warning_amber_outlined,
    NotificationType.information => Icons.info_outlined,
    NotificationType.error => Icons.dangerous_outlined,
  };
}

String notificationTitle(NotificationType notificationType) {
  return switch (notificationType) {
    NotificationType.success => 'Success Notification',
    NotificationType.warning => 'Warning Notification',
    NotificationType.information => 'Informational Notification',
    NotificationType.error => 'Error Notification',
  };
}

class NotificationTile extends StatefulWidget {
  const NotificationTile({
    this.title,
    this.content,
    this.notificationType = NotificationType.information,
    this.actions,
    this.duration = 7,
    super.key,
  });

  final String? title;
  final String? content;
  final NotificationType notificationType;
  final List<Widget>? actions;
  final int duration;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Timer? _autoHideTimer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    // Start auto-hide timer after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoHideTimer();
    });
  }

  void _startAutoHideTimer() {
    _autoHideTimer = Timer(Duration(seconds: widget.duration), () {
      dismissNotification();
    });
  }

  void dismissNotification() {
    // Prevent multiple dismissal attempts
    if (_dismissing || controller == null) return;

    _dismissing = true;

    // First reverse the animation
    controller!.reverse().then((_) {
      // Then remove the notification after animation completes
      if (mounted) {
        if (navkey.currentContext != null) {
          navkey.currentContext!.notify.removeNotification();
        }
      }
    });
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    // Ensure controller is properly disposed
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideInDown(
      controller: (ctrl) {
        controller = ctrl;
      },
      child: Dismissible(
        key: Key(
          widget.title ?? widget.content ?? DateTime.now().toIso8601String(),
        ),
        onDismissed: (direction) {
          // Direct dismissal by user gesture
          if (navkey.currentContext != null) {
            navkey.currentContext!.notify.removeNotification();
          }
        },
        direction: DismissDirection.up,
        child: Container(
          margin: EdgeInsets.only(top: context.mediaQuery.padding.top * 1.2),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: BrandColors.bc161622.withValues(alpha: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  iconType(widget.notificationType),
                  color: notificationColor(widget.notificationType),
                  size: 20.sp,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            size: 18.sp,
                            color: BrandColors.washedTextColor
                                .withValues(alpha: .6),
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              widget.title ??
                                  notificationTitle(widget.notificationType),
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: BrandColors.textColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (widget.content != null) ...{
                        4.verticalSpace,
                        Text(
                          widget.content!,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: BrandColors.washedTextColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      },
                      if (widget.actions != null &&
                          widget.actions!.isNotEmpty) ...{
                        4.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: widget.actions!,
                        ),
                      }
                    ],
                  ),
                ),
                8.horizontalSpace,
                InkWell(
                  onTap: dismissNotification,
                  child: Icon(
                    Icons.close,
                    color: BrandColors.washedTextColor.withValues(alpha: .5),
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ).padHorizontal,
      ),
    );
  }
}
