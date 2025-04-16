import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    required this.icon,
    required this.title,
    required this.subtilte,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtilte;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: BrandColors.textColor.withValues(alpha: .04),
            border: Border.all(
              color: BrandColors.textColor,
              width: .3.w,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 16.r,
              backgroundColor: BrandColors.textColor.withValues(alpha: .2),
              child: CustomIcon(
                icon: icon,
                width: 14.w,
                height: 14.h,
              ),
            ),
            title: Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
            ),
            subtitle: Text(
              subtilte,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: BrandColors.washedTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
