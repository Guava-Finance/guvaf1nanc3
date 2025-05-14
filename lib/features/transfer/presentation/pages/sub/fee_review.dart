import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/transfer/domain/usecases/wallet_transfer.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';

class FeeReview extends StatelessWidget {
  const FeeReview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final balance = ref.watch(balanceUsecaseProvider);
        final localAmount = ref.watch(localAountTransfer);
        final usdcAmount = ref.watch(usdcAountTransfer);
        final fee = ref.watch(calcTransactionFee);

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
              balance.when(
                data: (data) {
                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${data.symbol}${localAmount.formatAmount()}',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: BrandColors.textColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: (localAmount).formatDecimal,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: BrandColors.washedTextColor,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
                error: (_, __) => 0.verticalSpace,
                loading: () => 0.verticalSpace,
              ),
              15.verticalSpace,
              PaymentItem(
                title: 'Equivalent to',
                value: '',
              ),
              15.verticalSpace,
              PaymentItem(
                title: 'USDC',
                value: '$usdcAmount',
                isUsdc: true,
              ),
              15.verticalSpace,
              fee.when(
                data: (data) {
                  return PaymentItem(
                    title: 'Fee',
                    value: '$data',
                    isUsdc: true,
                  );
                },
                error: (e, __) {
                  return Text(
                    e.toString(),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 8.sp,
                    ),
                  );
                },
                loading: () {
                  return CupertinoActivityIndicator(
                    radius: 8.r,
                    color: BrandColors.primary,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
