import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/data/models/balance.param.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/home/presentation/widgets/status_item.dart';
import 'package:guava/features/home/presentation/widgets/txn_tile.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/utility_widget.dart';
import 'package:intl/intl.dart';

class TransactionFee extends StatelessWidget {
  const TransactionFee({
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
      child: Consumer(
        builder: (context, ref, child) {
          final txn = ref.watch(selectedTransactionHistory);
          final hn = ref.read(homeNotifierProvider);
          final balance = ref.watch(balanceUsecaseProvider.future);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              10.verticalSpace,
              FutureBuilder(
                future: balance,
                builder: (_, ss) {
                  if (ss.data == null) {
                    return 0.verticalSpace;
                  }

                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: ss.data!.symbol,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: BrandColors.textColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ((txn?.amount ?? 0.0) / ss.data!.exchangeRate)
                              .formatAmount(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: BrandColors.textColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ((txn?.amount ?? 0.0) / ss.data!.exchangeRate)
                              .formatDecimal,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: BrandColors.washedTextColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              30.verticalSpace,
              PaymentItem(
                title: 'Equivalent to',
                value: '',
              ),
              15.verticalSpace,
              PaymentItem(
                title: 'USDC',
                value: '${txn?.amount} USDC',
              ),
              15.verticalSpace,
              PaymentItem(
                title: 'Fee',
                value: '0.98 USDC',
              ),
              15.verticalSpace,
              PaymentItem(
                title: 'Date',
                value: DateFormat.yMMMEd().add_jmv().format(
                      txn?.timestamp ?? DateTime.now(),
                    ),
              ),
              15.verticalSpace,
              StatusItem(
                title: 'Status',
                widget: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: ShapeDecoration(
                    color: hn.txnColor(txn?.status).withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: hn.txnColor(txn?.status).withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Text(
                    txn?.status ?? '',
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: hn.txnColor(txn?.status),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
