import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
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
    return BackWrapper(
      title: 'Transaction details',
      trailing: Text(
        'Help?',
        style: context.textTheme.bodyMedium!.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: BrandColors.washedTextColor,
        ),
      ),
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                TransactionFee(),
                20.verticalSpace,
                TransactionDetail(),
                20.verticalSpace,
                CustomButton(
                  title: 'Share receipt',
                  onTap: () => context.push(
                    pPaymentStatus,
                  ),
                )
              ],
            ),
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: CircleAvatar(),
            ),
          ],
        ),
      ),
    );
  }
}
