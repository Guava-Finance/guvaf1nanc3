import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/usecases/countries_usecase.dart';
import 'package:guava/features/transfer/domain/usecases/wallet_transfer.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetail extends ConsumerWidget {
  const PaymentDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeState = ref.watch(activeTabState);
    final usdcAmount = ref.watch(usdcAountTransfer);
    final purpose = ref.watch(transferPurpose);
    final acctDetail = ref.watch(accountDetail);
    final country = ref.watch(selectedCountry);
    final txnId = ref.watch(transactionId);

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
            value: '',
          ),
          15.verticalSpace,
          PaymentItem(
            title: 'USDC',
            value: '$usdcAmount',
            isUsdc: true,
          ),
          15.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              final fee = ref.watch(calcTransactionFee);

              return fee.when(
                data: (data) {
                  return PaymentItem(
                    title: 'Fee',
                    value: '$data',
                    isUsdc: true,
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
          15.verticalSpace,
          if (activeState == 1) ...{
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
            15.verticalSpace,
          },
          Divider(color: BrandColors.light.withValues(alpha: 0.1)),
          TextButton(
            onPressed: () {
              var url =
                  'https://solscan.io/tx/$txnId${(ref.read(appConfig)?.isMainnet ?? true) ? '' : '?cluster=devnet'}';

              launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text(
              'View on Solscan',
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
