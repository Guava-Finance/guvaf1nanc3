import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/usecases/solana_pay.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/custom_button.dart';

class ReviewSolanaPayDetailPage extends ConsumerStatefulWidget {
  const ReviewSolanaPayDetailPage({super.key});

  @override
  ConsumerState<ReviewSolanaPayDetailPage> createState() =>
      _ReviewSolanaPayDetailPageState();
}

class _ReviewSolanaPayDetailPageState
    extends ConsumerState<ReviewSolanaPayDetailPage> with Loader {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Payment'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
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
                    ],
                  );
                },
              ),
            ),
            Spacer(),
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (_, data, child) {
                return CustomButton(
                  title: 'Make Payment',
                  onTap: () async {
                    await withLoading(() async {
                      final result = await ref
                          .read(transferNotifierProvider)
                          .processSolanaPay();

                      if (result) {
                        navkey.currentContext!.go(pSolanaPayStatus);
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
