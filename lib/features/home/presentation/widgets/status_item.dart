import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class StatusItem extends StatelessWidget {
  const StatusItem({
    required this.title,
    required this.widget,
    super.key,
  });

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: BrandColors.textColor,
          ),
        ),
        widget,
      ],
    );
  }
}
