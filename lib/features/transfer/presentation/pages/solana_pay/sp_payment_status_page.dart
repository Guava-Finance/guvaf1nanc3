import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/domain/usecases/history.dart';
import 'package:guava/features/transfer/domain/usecases/bank_beneficiary.dart';
import 'package:guava/features/transfer/domain/usecases/recent_bank_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/recent_wallet_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/save_to_address_book.dart';
import 'package:guava/features/transfer/domain/usecases/solana_pay.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SolanaPayStatusPage extends ConsumerStatefulWidget {
  const SolanaPayStatusPage({super.key});

  @override
  ConsumerState<SolanaPayStatusPage> createState() =>
      _SolanaPayStatusPageState();
}

class _SolanaPayStatusPageState extends ConsumerState<SolanaPayStatusPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // refresh the balance
      ref.invalidate(balanceUsecaseProvider);
      ref.invalidate(walletAddressProvider);
      ref.invalidate(myTransactionHistory);

      // refetch the recent transfer addresses
      ref.invalidate(recentWalletTransfers);
      ref.invalidate(recentBankTransfersProvider);
      ref.invalidate(addressBookProvider);
      ref.invalidate(bankBeneficiaryProvider);
    });
  }

  bool isSavedToAddresBook = false;

  @override
  Widget build(BuildContext context) {
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
                  20.verticalSpace,
                ],
              ),
            ),
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
              child: FutureBuilder(
                future: ref.watch(solanaPayInfo.future),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return 0.verticalSpace;
                  }

                  if (snapshot.hasError) {
                    context.pop();
                    context.pop();

                    context.notify.addNotification(
                      NotificationTile(
                        notificationType: NotificationType.error,
                        content: snapshot.error.toString(),
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PaymentItem(
                        title: 'Label',
                        value: snapshot.data?.label ?? '',
                      ),
                      15.verticalSpace,
                      PaymentItem(
                        title: 'To',
                        value:
                            (snapshot.data?.recipient ?? '').toMaskedFormat(),
                      ),
                      15.verticalSpace,
                      PaymentItem(
                        title: 'Amount',
                        value: snapshot.data?.amount ?? '',
                        isSol: snapshot.data!.splToken == null,
                        isUsdc: snapshot.data!.splToken != null,
                      ),
                      15.verticalSpace,
                      PaymentItem(
                        title: 'Fee',
                        value: snapshot.data?.fee ?? '',
                        isSol: snapshot.data!.splToken == null,
                        isUsdc: snapshot.data!.splToken != null,
                      ),
                      15.verticalSpace,
                      Divider(color: BrandColors.light.withValues(alpha: 0.1)),
                      TextButton(
                        onPressed: () {
                          final txnId = ref.read(transactionId);

                          launchUrl(
                            Uri.parse(
                                'https://solscan.io/tx/$txnId?cluster=devnet'),
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
                  );
                },
              ),
            ),
            20.verticalSpace,
            Spacer(),
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
