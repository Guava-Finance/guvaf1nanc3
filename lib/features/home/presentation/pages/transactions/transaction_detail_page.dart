import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/pages/sub/transaction_detail.dart';
import 'package:guava/features/home/presentation/pages/sub/transaction_fee.dart';
import 'package:guava/features/home/presentation/widgets/txn_tile.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:share_plus/share_plus.dart';

class TransactionDetailPage extends ConsumerWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction details'),
        actions: [
          Text(
            'Help?',
            style: context.textTheme.bodyMedium!.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: BrandColors.washedTextColor,
            ),
          ),
          16.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  40.verticalSpace,
                  TransactionFee(),
                  if (ref.read(selectedTransactionHistory)?.bankDetails !=
                      null) ...{
                    20.verticalSpace,
                    TransactionDetail(),
                  },
                  20.verticalSpace,
                ],
              ),
              Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: CircleAvatar(),
              ),
            ],
          ),
        ).padHorizontal,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          5.verticalSpace,
          CustomButton(
            title: 'Share receipt',
            onTap: () {
              final txnId =
                  ref.read(selectedTransactionHistory)?.explorerTransactionId;

              SharePlus.instance.share(
                ShareParams(
                  text: 'https://solscan.io/tx/$txnId?cluster=devnet',
                ),
              );
            },
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
