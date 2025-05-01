import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/usecases/countries_usecase.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';

class PaymentReview extends ConsumerWidget {
  const PaymentReview({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purpose = ref.watch(transferPurpose.notifier).state;
    final acctDetail = ref.watch(accountDetail.notifier).state;
    final country = ref.watch(selectedCountry.notifier).state;

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
          PaymentItem(
            title: 'Account number',
            value: acctDetail?.accountNumber ?? '',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Account name',
            value: acctDetail?.accountName ?? '',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Country',
            value: country?.name ?? '',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Bank',
            value: acctDetail?.bankName ?? '',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'Purpose',
            value: purpose,
          ),
          20.verticalSpace,
          Text(
            'Proceed below to complete transaction',
            style: context.textTheme.bodyMedium!.copyWith(
              fontSize: 10.sp,
              color: BrandColors.washedTextColor,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
