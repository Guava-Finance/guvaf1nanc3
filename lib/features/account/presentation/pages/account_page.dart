import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/utility_widget.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Text(
                  'My Account',
                  style: context.semiBold.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 25.h),
                Stack(
                  children: [
                    Container(
                      height: 60.h,
                      width: 100.w,
                      color: Colors.transparent,
                      child: CircleAvatar(
                        maxRadius: 10.r,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: Image.asset(
                        R.ASSETS_IMAGES_CAMERA_PNG,
                        height: 24.h,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'oghenevwegba05',
                  style: context.semiBold.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  '@oghenevwegba05',
                  style: context.medium.copyWith(
                    color: hexColor('#B0B7B1'),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 25.h),
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
                          backgroundColor:
                              hexColor('#FCFCFC').withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
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
                          backgroundColor:
                              hexColor('#FCFCFC').withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                  decoration: ShapeDecoration(
                      color: hexColor('#334e48'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      )),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            R.ASSETS_IMAGES_SETTINGS_PNG,
                            height: 19.h,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Text(
                              'Settings',
                              style: context.medium.copyWith(
                                  color: Colors.white, fontSize: 14.w),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Divider(
                            color:
                                hexColor('#FCFCFC').withValues(alpha: 0.3)),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            R.ASSETS_IMAGES_SECURITY_PNG,
                            height: 19.h,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Text(
                              'Privacy & security',
                              style: context.medium.copyWith(
                                  color: Colors.white, fontSize: 14.w),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Divider(
                            color:
                                hexColor('#FCFCFC').withValues(alpha: 0.3)),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            R.ASSETS_IMAGES_SUPPORT_PNG,
                            height: 19.h,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Text(
                              'Support',
                              style: context.medium.copyWith(
                                  color: Colors.white, fontSize: 14.w),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Divider(
                            color:
                                hexColor('#FCFCFC').withValues(alpha: 0.3)),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            R.ASSETS_IMAGES_TERMS_PNG,
                            height: 19.h,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Text(
                              'Terms of service',
                              style: context.medium.copyWith(
                                  color: Colors.white, fontSize: 14.w),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  'Version 2.4.2345 (7654)',
                  style: context.medium.copyWith(
                    color: hexColor('#B0B7B1'),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Copyright @Guavafi 2025. All rights reserved.',
                  style: context.medium.copyWith(
                    color: hexColor('#B0B7B1'),
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 20.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
