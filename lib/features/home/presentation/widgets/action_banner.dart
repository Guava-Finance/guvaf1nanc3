import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';

class ActionBanners extends StatelessWidget {
  const ActionBanners({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bannerKey,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback? onTap;
  final String bannerKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 6.w, left: 6.w),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: BrandColors.containerColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Align(
              child: Row(
                children: [
                  CustomIcon(
                    icon: icon,
                    width: 50.w,
                    height: 50.h,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        5.verticalSpace,
                        Row(
                          children: [
                            Text(
                              subtitle,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            3.horizontalSpace,
                            Icon(
                              Icons.arrow_forward,
                              color: BrandColors.textColor,
                              size: 16.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0.w,
              top: 0.h,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: CircleAvatar(
                  maxRadius: 10.r,
                  backgroundColor:
                      // ignore: deprecated_member_use
                      BrandColors.textColor.withOpacity(.2),
                  child: Icon(
                    Icons.close,
                    color: BrandColors.textColor,
                    size: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
