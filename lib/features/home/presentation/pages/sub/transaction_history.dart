import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/txn.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/history.dart';
import 'package:guava/features/home/presentation/widgets/txn_tile.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final txnHistory = ref.watch(allTransactionHistory);
        final txns = txnHistory.groupedbyDate;

        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              if (txns.isEmpty) ...{
                24.verticalSpace,
                Container(
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
                  alignment: Alignment.center,
                  child: Text(
                    'No result',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.washedTextColor,
                    ),
                  ),
                ),
              },
              for (var txn in txns.entries) ...{
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    24.verticalSpace,
                    Text(
                      txn.key,
                      style: context.medium.copyWith(
                        color: BrandColors.washedTextColor,
                        fontSize: 12.w,
                      ),
                    ),
                    12.verticalSpace,
                    Container(
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: txn.value.length,
                        separatorBuilder: (ctx, i) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Divider(
                            color: BrandColors.washedTextColor.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        itemBuilder: (ctx, i) {
                          return TransactionHistoryTile(
                            data: txn.value[i],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              },
              40.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
