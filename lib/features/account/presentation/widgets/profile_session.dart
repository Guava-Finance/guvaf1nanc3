import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';

class AccountProfileSession extends StatelessWidget {
  const AccountProfileSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              height: 60.h,
              width: 100.w,
              color: Colors.transparent,
              child: CircleAvatar(maxRadius: 30.r),
            ),
            Positioned(
              bottom: 0,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: BrandColors.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: BrandColors.backgroundColor,
                    width: 3.w,
                  ),
                ),
                child: CircleAvatar(
                  maxRadius: 12.r,
                  backgroundColor: BrandColors.textColor,
                  child: CustomIcon(
                    icon: R.ASSETS_ICONS_CAMERA_SVG,
                    width: 11.w,
                    height: 11.h,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          'John Doe',
          style: context.semiBold.copyWith(
            color: BrandColors.textColor,
            fontSize: 18.sp,
          ),
        ),
        3.verticalSpace,
        Text(
          '@johndoe',
          style: context.medium.copyWith(
            color: BrandColors.washedTextColor,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
