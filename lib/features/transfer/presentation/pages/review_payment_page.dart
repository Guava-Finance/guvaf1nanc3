import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/pages/sub/fee_review.dart';
import 'package:guava/features/transfer/presentation/pages/sub/payment_review.dart';
import 'package:guava/widgets/custom_button.dart';

class ReviewPaymentPage extends ConsumerStatefulWidget {
  const ReviewPaymentPage({super.key});

  @override
  ConsumerState<ReviewPaymentPage> createState() => _ReviewPaymentPageState();
}

class _ReviewPaymentPageState extends ConsumerState<ReviewPaymentPage>
    with Loader {
  @override
  Widget build(BuildContext context) {
    final activeState = ref.watch(activeTabState.notifier).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Payment'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
            FeeReview(),
            20.verticalSpace,
            if (activeState == 1) ...{
              PaymentReview(),
            },
            Spacer(),
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (_, data, child) {
                return CustomButton(
                  title: 'Complete Transfer',
                  onTap: () async {
                    await withLoading(() async {
                      final result = await ref
                          .read(transferNotifierProvider)
                          .makeWalletTransfer();

                      if (result) {
                        navkey.currentContext!.go(pPaymentStatus);
                      }
                    });
                  },
                  isLoading: data,
                );
              },
            )
          ],
        ).padHorizontal,
      ),
    );
  }
}
