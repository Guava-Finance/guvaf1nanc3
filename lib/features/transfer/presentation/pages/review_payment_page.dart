import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/presentation/pages/sub/fee_review.dart';
import 'package:guava/features/transfer/presentation/pages/sub/payment_review.dart';
import 'package:guava/widgets/back_wrapper.dart';
import 'package:guava/widgets/custom_button.dart';

class ReviewPaymentPage extends ConsumerWidget {
  const ReviewPaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackWrapper(
      title: 'Review Payment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeeReview(),
          20.verticalSpace,
          PaymentReview(),
          Spacer(),
          CustomButton(
            title: 'Complete transaction',
            onTap: () => context.push(
              pPaymentStatus
            ),
          )
        ],
      ),
    );
  }
}
