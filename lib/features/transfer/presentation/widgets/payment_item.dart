import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    required this.title,
    required this.value,
    this.isUsdc = false,
    this.isSol = false,
    this.valueWidget,
    super.key,
  });

  final String title;
  final String value;
  final bool isUsdc;
  final bool isSol;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: BrandColors.textColor,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: (isUsdc || isSol)
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: value),
                      TextSpan(text: ' '),
                      if (isUsdc) ...{
                        WidgetSpan(
                          child: CustomIcon(
                            icon: R.ASSETS_ICONS_USD_COIN_SVG,
                            height: 16.h,
                            width: 16.w,
                          ),
                        ),
                      },
                      if (isSol) ...{
                        WidgetSpan(
                          child: CustomIcon(
                            icon: R.ASSETS_ICONS_SOLANA_SOL_ICON_SVG,
                            height: 13.h,
                            width: 13.w,
                          ),
                        ),
                      }
                    ],
                  ),
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: BrandColors.washedTextColor,
                  ),
                  textAlign: TextAlign.end,
                )
              : valueWidget ??
                  Text(
                    value,
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: BrandColors.washedTextColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
        ),
      ],
    );
  }
}
