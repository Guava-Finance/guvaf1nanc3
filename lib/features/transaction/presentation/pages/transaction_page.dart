import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/pages/sub/payment_detail.dart';
import 'package:guava/widgets/back_wrapper.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/utility_widget.dart';

class PaymentStatusPage extends ConsumerWidget {
  const PaymentStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackWrapper(
      title: '',
      hasBackButton: false,
      trailing: Text(
        'Done',
        style: context.textTheme.bodyMedium!.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: BrandColors.washedTextColor,
        ),
      ),
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
                5.verticalSpace,
                Text(
                  'Transfer successful',
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: BrandColors.light,
                  ),
                ),
                10.verticalSpace,
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
                20.verticalSpace,
              ],
            ),
          ),
          PaymentDetail(),
          20.verticalSpace,
          Spacer(),
          CustomButton(
            title: 'Add to beneficiary',
            onTap: () => context.push(
              pPaymentStatus,
            ),
            backgroundColor: BrandColors.containerColor,
            textColor: BrandColors.washedTextColor,
          ),
          10.verticalSpace,
          CustomButton(
            title: 'Share receipt',
            onTap: () => context.push(
              pPaymentStatus,
            ),
          )
        ],
      ),
    );
  }
}
