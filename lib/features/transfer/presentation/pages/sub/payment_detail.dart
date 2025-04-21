import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/utility_widget.dart';

class PaymentDetail extends StatelessWidget {
  const PaymentDetail({
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
          10.verticalSpace,
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
          15.verticalSpace,
          PaymentItem(
            title: 'Account number',
            value: '9024510486',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Account name',
            value: 'Israel Elisha',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Country',
            value: 'Ghana',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Bank',
            value: 'Ghana Commercial Bank',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Purpose',
            value: 'School',
          ),
          15.verticalSpace,
          Divider(color: BrandColors.light.withValues(alpha: 0.1)),
          TextButton(
            onPressed: () => context.push(pTransactionDetail),
            child: Text(
              'View details',
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: BrandColors.washedTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
