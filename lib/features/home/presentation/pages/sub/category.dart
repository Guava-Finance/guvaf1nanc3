
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/widgets/category.dart';

class CategorySession extends StatelessWidget {
  const CategorySession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Categories',
          style: context.medium.copyWith(
            color: BrandColors.textColor,
            fontSize: 16.sp,
          ),
        ),
        8.verticalSpace,
        SizedBox(
          height: 140.h,
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runAlignment: WrapAlignment.spaceEvenly,
            children: [
              CategoryTile(
                title: 'Savings',
                icon: R.ASSETS_ICONS_SAVINGS_ICON_SVG,
                color: BrandColors.washedYellow,
              ),
              CategoryTile(
                title: 'Excrow',
                icon: R.ASSETS_ICONS_TAG_ICON_SVG,
                color: BrandColors.washedBlue,
              ),
              CategoryTile(
                title: 'Statement',
                icon: R.ASSETS_ICONS_STATEMENT_ICON_SVG,
                color: BrandColors.washedGreen,
              ),
              CategoryTile(
                title: 'Invite Friends',
                icon: R.ASSETS_ICONS_INVITE_ICON_SVG,
                color: BrandColors.washedRed,
              ),
            ],
          ),
        ),
      ],
    ).padHorizontal;
  }
}
