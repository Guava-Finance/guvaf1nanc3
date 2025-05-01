import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/pages/sub/transaction_history.dart';
import 'package:guava/widgets/back_wrapper.dart';

class TransactionFilterPage extends ConsumerWidget {
  const TransactionFilterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackWrapper(
      title: 'Filter',
      child: Column(
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
                    // controller: controller,
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
          20.verticalSpace,
          TransactionHistory()
        ],
      ),
    );
  }
}
