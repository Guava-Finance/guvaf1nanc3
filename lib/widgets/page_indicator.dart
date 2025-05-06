
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.currentPage,
    required this.totalPages,
    super.key,
  });

  final int totalPages;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'page_indicator',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < totalPages; i++)
            AnimatedContainer(
              width: i == currentPage ? 24.w : 4.w,
              height: 4.h,
              duration: Durations.medium3,
              margin: EdgeInsets.only(
                right: 2.w,
                left: 2.w,
              ),
              decoration: BoxDecoration(
                color: i == currentPage
                    ? BrandColors.textColor
                    : BrandColors.disabledTextColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
        ],
      ),
    );
  }
}
