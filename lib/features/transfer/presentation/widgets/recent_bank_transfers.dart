import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/recents_bt_tile.dart';

class RecentBankTransfers extends StatelessWidget {
  const RecentBankTransfers({
    required this.controller, super.key,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              fillColor: BrandColors.containerColor,
              filled: true,
              suffixIconConstraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: SvgPicture.asset(R.ASSETS_ICONS_SEARCH_SVG),
              ),
              hintText: 'Search names',
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
            style: context.textTheme.bodyMedium,
          ).padHorizontal,
          15.verticalSpace,
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
                return RecentsBankTransferTile();
              },
            ),
          ).padHorizontal,
          15.verticalSpace
        ],
      ),
    );
  }
}