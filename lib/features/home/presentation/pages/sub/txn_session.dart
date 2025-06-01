import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/history.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/home/presentation/widgets/txn_tile.dart';
import 'package:showcaseview/showcaseview.dart';

class TransactionHistorySession extends StatelessWidget {
  const TransactionHistorySession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaction history',
              style: context.medium.copyWith(
                color: BrandColors.textColor,
                fontSize: 16.w,
              ),
            ),
            Showcase(
              key: allTransactionsButtonWidgetKey,
              description: 'Tap here to see all your transactions and more',
              child: GestureDetector(
                onTap: () {
                  context.push(pTransaction);
                  HapticFeedback.lightImpact();
                },
                child: Text(
                  'View all',
                  style: context.medium.copyWith(
                    color: BrandColors.washedTextColor,
                    fontSize: 14.w,
                  ),
                ),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Showcase(
          key: transactionSessionWidgetKey,
          description: 'Your last recent 3 transactions appear here',
          targetBorderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 15.w,
            ),
            decoration: ShapeDecoration(
              color: BrandColors.containerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final txnHistory = ref.watch(myTransactionHistory);

                return txnHistory.when(
                  data: (data) {
                    return (data ?? []).isEmpty
                        ? Center(
                            child: Text('No transactions'),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: (data ?? []).take(3).length,
                            separatorBuilder: (ctx, i) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Divider(
                                color: BrandColors.washedTextColor
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            itemBuilder: (ctx, i) {
                              return TransactionHistoryTile(
                                data: (data ?? [])[i],
                              );
                            },
                          );
                  },
                  error: (_, __) {
                    return Center(
                      child: Text(
                        'Something went wrong',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: BrandColors.washedTextColor,
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return Center(
                      child: CupertinoActivityIndicator(
                        radius: 16.r,
                        color: BrandColors.primary,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    ).padHorizontal;
  }
}
