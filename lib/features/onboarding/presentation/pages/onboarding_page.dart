import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/utility_widget.dart';

class Onboardingpage extends ConsumerWidget {
  const Onboardingpage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
                children: [
                  Image.asset(R.ASSETS_IMAGES_ONBOARD_IMAGE1_PNG),
                  Image.asset(R.ASSETS_IMAGES_ONBOARD_IMAGE2_PNG),
                  Image.asset(R.ASSETS_IMAGES_ONBOARD_IMAGE3_PNG),
                  Image.asset(R.ASSETS_IMAGES_ONBOARD_IMAGE4_PNG),
                  Image.asset(R.ASSETS_IMAGES_ONBOARD_IMAGE5_PNG),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: false,
                        onChanged: (value) {},
                        activeColor: Colors.white,
                        fillColor: WidgetStateProperty.all(Colors.white),
                      ),
                      Text(
                        'I agree to the Terms of Service',
                        style: context.medium.copyWith(
                          color: hexColor('#FCFCFC')
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  CustomButton(onTap: () {}, title: 'Create a new wallet',),
                  SizedBox(height: 5.h),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'I already have a wallet',
                        style: context.medium.copyWith(
                            fontSize: 14.sp, color: hexColor('#FCFCFC')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      )),
    );
  }
}
