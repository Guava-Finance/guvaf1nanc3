import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';

class TransferTile extends StatelessWidget {
  const TransferTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          maxRadius: 20.r,
          backgroundColor: BrandColors.lightGreen,
          child: CustomIcon(
            icon: R.ASSETS_ICONS_WALLET_ICON_SVG,
            color: BrandColors.backgroundColor,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '9Cu6uYFinFz6wd3iJPoPvTiTVsgxnKzZNhgkbJXnAaP1'.toMaskedFormat(),
                style: context.medium.copyWith(
                  color: BrandColors.light,
                  fontSize: 12.sp,
                ),
              ),
              5.verticalSpace,
              Text(
                'Used 12:55pm',
                style: context.medium.copyWith(
                  color: BrandColors.washedTextColor,
                  fontSize: 12.w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
