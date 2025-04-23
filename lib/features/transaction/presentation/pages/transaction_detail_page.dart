import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transaction/presentation/pages/sub/transaction_detail.dart';
import 'package:guava/features/transaction/presentation/pages/sub/transaction_fee.dart';
import 'package:guava/widgets/back_wrapper.dart';
import 'package:guava/widgets/custom_button.dart';

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
                  20.verticalSpace,
                  TransactionDetail(),
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
            onTap: () => context.push(
              pPaymentStatus,
            ),
          ),
          20.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
