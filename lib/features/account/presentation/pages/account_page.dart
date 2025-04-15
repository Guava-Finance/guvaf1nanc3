import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/widgets/profile_session.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/utility_widget.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            12.verticalSpace,
            Text(
              'My Account',
              style: context.semiBold.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
            12.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    12.verticalSpace,
                    AccountProfileSession(),
                    24.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52.h,
                            child: CustomButton(
                              onTap: () {},
                              title: 'Edit profile',
                              textColor: Colors.white,
                              filled: false,
                              showBorder: true,
                              radius: 12.r,
                              backgroundColor: BrandColors.textColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: SizedBox(
                            height: 52.h,
                            child: CustomButton(
                              onTap: () {},
                              title: 'Invite friends',
                              textColor: Colors.white,
                              filled: false,
                              showBorder: true,
                              radius: 12.r,
                              backgroundColor: BrandColors.textColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    24.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                        horizontal: 24.w,
                      ),
                      decoration: ShapeDecoration(
                        color: BrandColors.containerColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CustomIcon(
                              icon: R.ASSETS_ICONS_SETTINGS_SVG,
                              color: BrandColors.textColor,
                              width: 20.w,
                              height: 20.h,
                            ),
                            title: Text(
                              'Settings',
                              style: context.medium.copyWith(
                                color: BrandColors.textColor,
                                fontSize: 14.w,
                              ),
                            ),
                          ),
                          Divider(
                            color: BrandColors.textColor.withValues(alpha: 0.1),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CustomIcon(
                              icon: R.ASSETS_ICONS_LOCK_SVG,
                              color: BrandColors.textColor,
                              width: 20.w,
                              height: 20.h,
                            ),
                            title: Text(
                              'Privacy & security',
                              style: context.medium.copyWith(
                                color: BrandColors.textColor,
                                fontSize: 14.w,
                              ),
                            ),
                          ),
                          Divider(
                            color: BrandColors.textColor.withValues(alpha: 0.1),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CustomIcon(
                              icon: R.ASSETS_ICONS_SUPPORT_SVG,
                              color: BrandColors.textColor,
                              width: 20.w,
                              height: 20.h,
                            ),
                            title: Text(
                              'Support',
                              style: context.medium.copyWith(
                                color: BrandColors.textColor,
                                fontSize: 14.w,
                              ),
                            ),
                          ),
                          Divider(
                            color: BrandColors.textColor.withValues(alpha: 0.1),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CustomIcon(
                              icon: R.ASSETS_ICONS_TERMS_SVG,
                              color: BrandColors.textColor,
                            ),
                            title: Text(
                              'Terms of service',
                              style: context.medium.copyWith(
                                color: BrandColors.textColor,
                                fontSize: 14.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    100.verticalSpace,
                    Text(
                      'Version 2.4.2345 (7654)',
                      style: context.medium.copyWith(
                        color: hexColor('#B0B7B1'),
                        fontSize: 12.sp,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      'Copyright @Guavafi 2025. All rights reserved.',
                      style: context.medium.copyWith(
                        color: hexColor('#B0B7B1'),
                        fontSize: 10.sp,
                      ),
                    ),
                    20.verticalSpace,
                  ],
                ).padHorizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
