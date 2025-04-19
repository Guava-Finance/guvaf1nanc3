import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/utility_widget.dart';

class FeeReview extends StatelessWidget {
  const FeeReview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 15.h,
        horizontal: 15.w,
      ),
      decoration: BoxDecoration(
        color: BrandColors.containerColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: BrandColors.textColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: currencyFormatter().format(5000.89),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: BrandColors.textColor,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: (5000.89).formatDecimal,
                  style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.washedTextColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Equivalent to',
            value: currencyFormatter().format(120000.98),
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'USDC',
            value: '100.00 USDC',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Fee',
            value: '0.98 USDC',
          ),
        ],
      ),
    );
  }
}