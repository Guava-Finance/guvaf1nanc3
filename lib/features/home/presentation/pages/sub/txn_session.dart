import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/widgets/txn_tile.dart';

class TransactionHistorySession extends StatelessWidget {
  const TransactionHistorySession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            GestureDetector(
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
          ],
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
            itemCount: 3,
            separatorBuilder: (ctx, i) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(
                color: BrandColors.washedTextColor.withValues(alpha: 0.3),
              ),
            ),
            itemBuilder: (ctx, i) {
              return TransactionHistoryTile();
            },
          ),
        ),
      ],
    ).padHorizontal;
  }
}
