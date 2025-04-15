import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/utility_widget.dart';

class WalletDetails extends StatelessWidget {
  const WalletDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 10.w,
          ),
          decoration: ShapeDecoration(
            color: BrandColors.containerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Main Wallet',
            style: context.medium.copyWith(
              color: BrandColors.textColor,
              fontSize: 12.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 10.w,
          ),
          decoration: ShapeDecoration(
            color: BrandColors.containerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            children: [
              Text(
                '9Cu6uYFinFz6wd3iJPoPvTiTVsgxnKzZNhgkbJXnAaP1'.toMaskedFormat(),
                style: context.medium.copyWith(
                  color: hexColor('#B0B7B1'),
                  fontSize: 12.sp,
                ),
              ),
              4.horizontalSpace,
              InkWell(
                onTap: () {
                  Clipboard.getData(
                    '9Cu6uYFinFz6wd3iJPoPvTiTVsgxnKzZNhgkbJXnAaP1',
                  ).then((_) {});
                },
                child: CustomIcon(
                  icon: R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG,
                  height: 16.h,
                  width: 16.w,
                ),
              ),
            ],
          ),
        ),
      ],
    ).padHorizontal;
  }
}
