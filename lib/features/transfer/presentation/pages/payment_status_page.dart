import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/domain/usecases/history.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/transfer/domain/usecases/address_book.dart';
import 'package:guava/features/transfer/domain/usecases/bank_beneficiary.dart';
import 'package:guava/features/transfer/domain/usecases/recent_bank_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/recent_wallet_transfer.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/pages/sub/address-book_new.dart';
import 'package:guava/features/transfer/presentation/pages/sub/payment_detail.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:share_plus/share_plus.dart';

class PaymentStatusPage extends ConsumerStatefulWidget {
  const PaymentStatusPage({super.key});

  @override
  ConsumerState<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends ConsumerState<PaymentStatusPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // refresh the balance
      ref.invalidate(balanceUsecaseProvider);
      ref.invalidate(walletAddressProvider);
      ref.invalidate(myTransactionHistory);
      ref.invalidate(payingAnyone);

      // refetch the recent transfer addresses
      ref.invalidate(recentWalletTransfers);
      ref.invalidate(recentBankTransfersProvider);
      ref.invalidate(myAddressBook);
      ref.invalidate(bankBeneficiaryProvider);
    });
  }

  bool isSavedToAddresBook = false;

  @override
  Widget build(BuildContext context) {
    final activeState = ref.read(activeTabState.notifier).state;

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              final txnId = ref.read(transactionId.notifier).state;

              SharePlus.instance.share(
                ShareParams(
                  text: 'https://solscan.io/tx/$txnId?cluster=devnet',
                ),
              );
            },
            child: Text(
              'Share reciept',
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
                  CircleAvatar(
                    maxRadius: 16.r,
                    backgroundColor: BrandColors.primary,
                    child: Icon(
                      Icons.check,
                      color: BrandColors.backgroundColor,
                    ),
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
            if (!isSavedToAddresBook) ...{
              CustomButton(
                title: activeState == 0
                    ? 'Save to Address Book'
                    : 'Add to beneficiary',
                onTap: () {
                  if (activeState == 0) {
                    AddToAddressBook(
                      onSaved: (p0) {
                        setState(() => isSavedToAddresBook = p0);

                        ref.invalidate(myAddressBook);
                      },
                    ).bottomSheet;
                  }
                },
                backgroundColor: BrandColors.containerColor,
                textColor: BrandColors.washedTextColor,
              ),
              10.verticalSpace,
            },
            CustomButton(
              title: 'Done',
              onTap: () {
                context.toPath(pDashboard);
              },
            )
          ],
        ).padHorizontal,
      ),
    );
  }
}
