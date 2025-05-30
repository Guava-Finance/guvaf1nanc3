import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/avatar.dart';

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
              child: AppAvatar(radius: 30),
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
                child: GestureDetector(
                  onTap: () {},
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
        12.verticalSpace,
        Consumer(
          builder: (context, ref, child) {
            final username = ref.watch(myUsernameProvider);

            return username.when(
              data: (data) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            BrandColors.washedTextColor.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        '@$data',
                        style: context.medium.copyWith(
                          color: BrandColors.washedTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: BrandColors.primary,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIcon(
                            icon: R.ASSETS_ICONS_COIN_SVG,
                            color: BrandColors.backgroundColor,
                            width: 14.w,
                            height: 14.h,
                          ),
                          3.horizontalSpace,
                          Text(
                            '0.0',
                            style: context.medium.copyWith(
                              color: BrandColors.backgroundColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (_, __) => 0.verticalSpace,
              loading: () => CupertinoActivityIndicator(
                color: BrandColors.primary,
                radius: 12.r,
              ),
            );
          },
        ),
      ],
    );
  }
}
