import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/avatar.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            AppAvatar(),
            10.horizontalSpace,
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Hey\n',
                    style: context.medium.copyWith(
                      color: BrandColors.selectedNavBarLabel,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    text: 'Vwegba',
                    style: context.medium.copyWith(
                      color: BrandColors.textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: CustomIcon(
                icon: R.ASSETS_ICONS_SCAN_ICON_SVG,
                height: 20.h,
                width: 20.w,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: CustomIcon(
                icon: R.ASSETS_ICONS_NOTIFICATION_ICON_SVG,
                height: 20.h,
                width: 20.w,
              ),
            ),
          ],
        ),
      ],
    ).padHorizontal;
  }
}
