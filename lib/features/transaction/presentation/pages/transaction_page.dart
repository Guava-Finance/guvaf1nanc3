import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transaction/presentation/pages/sub/transaction_history.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          Text(
            'Download',
            style: context.textTheme.bodyMedium!.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: BrandColors.washedTextColor,
            ),
          ),
          16.horizontalSpace,
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: BrandColors.containerColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: BrandColors.textColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextFormField(
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
                      hintText: 'Search transactions',
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.washedTextColor,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none),
                    ),
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ),
              5.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: BrandColors.containerColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: BrandColors.textColor.withValues(alpha: 0.1),
                  ),
                ),
                child: SvgPicture.asset(R.ASSETS_ICONS_FILTER_SVG),
              )
            ],
          ),
          8.verticalSpace,
          Expanded(
            child: TransactionHistory(),
          ),
        ],
      ).padHorizontal,
    );
  }
}
