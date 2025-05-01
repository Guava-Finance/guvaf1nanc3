import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';

extension WidgetExtension on Widget {
  /// Adds padding to the widget.
  Widget get pad => Padding(
        padding: EdgeInsets.all(16.sp),
        child: this,
      );

  Widget get padHorizontal => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: this,
      );

  Future<dynamic> get bottomSheet {
    return showModalBottomSheet<dynamic>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      enableDrag: true,
      isScrollControlled: true,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.bounceIn,
        duration: Durations.extralong1,
        reverseCurve: Curves.bounceOut,
        reverseDuration: Durations.medium2,
      ),
      constraints: BoxConstraints(
        maxHeight: 700.h,
        minHeight: 200.h,
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
      context: navkey.currentContext!,
      backgroundColor: BrandColors.backgroundColor,
      builder: (_) => Material(
        color: Colors.transparent,
        child: this,
      ),
    );
  }
}
