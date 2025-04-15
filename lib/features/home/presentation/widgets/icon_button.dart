
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    required this.action,
    required this.icon,
    this.onTap,
    this.color,
    super.key,
  });

  final String action;
  final VoidCallback? onTap;
  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color ?? BrandColors.light,
            maxRadius: 24.r,
            child: CustomIcon(
              icon: icon,
              width: 12.w,
              height: 16.h,
            ),
          ),
          5.verticalSpace,
          Text(
            action,
            style: context.medium.copyWith(
              color: BrandColors.light,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
