import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/pages/sub/payment_detail.dart';
import 'package:guava/widgets/custom_button.dart';

class PaymentStatusPage extends ConsumerWidget {
  const PaymentStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeState = ref.read(activeTabState.notifier).state;

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              context.go(pDashboard);
            },
            child: Text(
              'Done',
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: BrandColors.washedTextColor,
              ),
            ),
          ),
          16.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Center(
              child: Column(
                children: [
                  Image.asset(
                    R.ASSETS_IMAGES_CHECKMARK_PNG,
                    height: 32.h,
                  ),
                  15.verticalSpace,
                  Text(
                    'Transfer successful',
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: BrandColors.light,
                    ),
                  ),
                  10.verticalSpace,
                  Consumer(
                    builder: (context, ref, child) {
                      final balance = ref.watch(balanceUsecaseProvider);
                      final amount =
                          ref.watch(localAountTransfer.notifier).state;

                      return balance.when(
                        data: (data) {
                          return Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '''${data.symbol}${amount.formatAmount()}''',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: BrandColors.textColor,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: amount.formatDecimal,
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
                        error: (_, __) {
                          return 0.verticalSpace;
                        },
                        loading: () {
                          return 0.verticalSpace;
                        },
                      );
                    },
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
            PaymentDetail(),
            20.verticalSpace,
            Spacer(),
            CustomButton(
              title: activeState == 0
                  ? 'Save to Address Book'
                  : 'Add to beneficiary',
              onTap: () {},
              backgroundColor: BrandColors.containerColor,
              textColor: BrandColors.washedTextColor,
            ),
            10.verticalSpace,
            CustomButton(
              title: 'Share receipt',
              onTap: () {},
            )
          ],
        ).padHorizontal,
      ),
    );
  }
}
