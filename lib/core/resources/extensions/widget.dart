import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
}
