import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as refresh;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/recents_bt_tile.dart';

class RecentBankTransfers<T> extends StatelessWidget {
  const RecentBankTransfers({
    required this.onRefresh,
    this.list,
    this.isLoading = false,
    this.onTap,
    super.key,
  });

  final bool isLoading;
  final List<T>? list;
  final refresh.RefreshCallback onRefresh;
  final Function(T)? onTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: list == null || isLoading
          ? ListView(
              children: [
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
                  child: CupertinoActivityIndicator(
                    radius: 16.r,
                    animating: true,
                    color: BrandColors.primary,
                  ),
                ).padHorizontal,
              ],
            )
          : list!.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
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
                      child: Text(
                        'no record found',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: BrandColors.washedTextColor,
                        ),
                      ),
                    ).padHorizontal,
                  ],
                )
              : Container(
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 15.w,
                    ),
                    itemCount: list!.take(3).length,
                    separatorBuilder: (ctx, i) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Divider(
                        color:
                            BrandColors.washedTextColor.withValues(alpha: 0.3),
                      ),
                    ),
                    itemBuilder: (ctx, i) {
                      return RecentsBankTransferTile(
                        data: list![i],
                        onTap: onTap,
                      );
                    },
                  ),
                ),
    );
  }
}
