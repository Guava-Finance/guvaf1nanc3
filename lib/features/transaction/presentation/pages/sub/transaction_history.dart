import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/widgets/txn_tile.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < 3; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                24.verticalSpace,
                Text(
                  'Today',
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
                    itemCount: 2,
                    separatorBuilder: (ctx, i) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Divider(
                        color: BrandColors.washedTextColor.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    itemBuilder: (ctx, i) {
                      return TransactionHistoryTile();
                    },
                  ),
                ),
              ],
            ),
          40.verticalSpace,
        ],
      ),
    );
  }
}
