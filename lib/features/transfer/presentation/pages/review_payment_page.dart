import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/pages/sub/fee_review.dart';
import 'package:guava/features/transfer/presentation/pages/sub/payment_review.dart';
import 'package:guava/widgets/custom_button.dart';

class ReviewPaymentPage extends ConsumerStatefulWidget {
  const ReviewPaymentPage({
    super.key,
    this.fromPayAnyone = false,
  });

  final bool fromPayAnyone;

  @override
  ConsumerState<ReviewPaymentPage> createState() => _ReviewPaymentPageState();
}

class _ReviewPaymentPageState extends ConsumerState<ReviewPaymentPage>
    with Loader {
  @override
  Widget build(BuildContext context) {
    ref
        .read(firebaseAnalyticsProvider)
        .triggerScreenLogged(runtimeType.toString());

    final activeState = ref.watch(activeTabState);

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
            if (activeState == 1 || widget.fromPayAnyone) ...{
              PaymentReview(),
            },
            Spacer(),
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (_, data, child) {
                return CustomButton(
                  title: 'Complete Transfer',
                  onTap: () async {
                    context.push(pAuthorizeTxn).then((v) async {
                      if (v != null) {
                        if ((v as bool)) {
                          await withLoading(() async {
                            late bool result;

                            if (activeState == 0 && !widget.fromPayAnyone) {
                              result = await ref
                                  .read(transferNotifierProvider)
                                  .makeWalletTransfer();
                            } else {
                              result = await ref
                                  .read(transferNotifierProvider)
                                  .makeABankTransfer();
                            }

                            if (result) {
                              navkey.currentContext!.go(pPaymentStatus);
                            }
                          });
                        }
                      }
                    });
                  },
                  isLoading: data,
                );
              },
            ),
            15.verticalSpace,
          ],
        ).padHorizontal,
      ),
    );
  }
}
