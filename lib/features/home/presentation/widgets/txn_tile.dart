import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:intl/intl.dart';

class TransactionHistoryTile extends StatelessWidget {
  const TransactionHistoryTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '₦', decimalDigits: 2);

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
                'Transfer to UGfGbfh...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.medium.copyWith(
                  color: BrandColors.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.w,
                ),
              ),
              5.verticalSpace,
              Row(
                children: [
                  Text(
                    DateFormat('MMM dd').format(DateTime.now()),
                    style: context.medium.copyWith(
                      color: BrandColors.washedTextColor,
                      fontSize: 12.w,
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 10.h,
                    color: BrandColors.washedTextColor.withValues(alpha: 0.3),
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                  ),
                  Text(
                    DateFormat.jmv().format(DateTime.now()),
                    style: context.medium.copyWith(
                      color: BrandColors.washedTextColor,
                      fontSize: 12.w,
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 10.h,
                    color: BrandColors.washedTextColor.withValues(alpha: 0.3),
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                  ),
                  Text(
                    'Wallet',
                    style: context.medium.copyWith(
                      color: BrandColors.washedTextColor,
                      fontSize: 12.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currency.format(91000.89),
              style: context.medium.copyWith(
                color: Colors.white,
                fontSize: 16.w,
              ),
            ),
            5.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
                horizontal: 8.w,
              ),
              decoration: ShapeDecoration(
                color: BrandColors.washedYellow.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: BrandColors.washedYellow.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Text(
                'Pending',
                style: context.medium.copyWith(
                  color: BrandColors.washedYellow,
                  fontSize: 10.sp,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
