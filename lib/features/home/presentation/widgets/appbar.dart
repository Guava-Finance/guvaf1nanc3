import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/avatar.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeAppbar extends ConsumerWidget {
  const HomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Showcase(
              key: avatarWidgetKey,
              description:
                  '''Your wallet personality. This can be modified on the accounts session''',
              targetBorderRadius: BorderRadius.circular(30.r),
              child: AppAvatar(),
            ),
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
                    text:
                        '''Good ${ref.read(homeNotifierProvider).getTimeOfDayGreeting}''',
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
