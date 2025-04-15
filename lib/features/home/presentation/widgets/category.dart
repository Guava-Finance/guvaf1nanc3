import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.title,
    required this.icon,
    this.color,
    this.onTap,
    super.key,
  });

  final String title;
  final String icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.mediaQuery.size.width * 0.43,
        padding: EdgeInsets.fromLTRB(
          25.w,
          20.h,
          0,
          20.h,
        ),
        decoration: ShapeDecoration(
          color: color ?? BrandColors.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Row(
          children: [
            CustomIcon(
              icon: icon,
              width: 16.w,
              height: 16.h,
            ),
            10.horizontalSpace,
            Text(
              title,
              style: context.medium.copyWith(
                color: BrandColors.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
