import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/widgets/txn_tile.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/utility_widget.dart';

class TransactionDetail extends StatelessWidget {
  const TransactionDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final txn = ref.watch(selectedTransactionHistory);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank details',
              style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: BrandColors.washedTextColor,
                  fontSize: 12.sp),
            ),
            10.verticalSpace,
            Container(
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
                  15.verticalSpace,
                  PaymentItem(
                    title: 'Account number',
                    value: txn?.bankDetails?.accountNumber ?? '',
                  ),
                  15.verticalSpace,
                  PaymentItem(
                    title: 'Account name',
                    value: txn?.bankDetails?.accountName ?? '',
                  ),
                  15.verticalSpace,
                  PaymentItem(
                    title: 'Country',
                    value: txn?.bankDetails?.country ?? '',
                  ),
                  15.verticalSpace,
                  PaymentItem(
                    title: 'Bank',
                    value: txn?.bankDetails?.bank ?? '',
                  ),
                  15.verticalSpace,
                  PaymentItem(
                    title: 'Purpose',
                    value: txn?.bankDetails?.purpose ?? '',
                  ),
                  15.verticalSpace,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
