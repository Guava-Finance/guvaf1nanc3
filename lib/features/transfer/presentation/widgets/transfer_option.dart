import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class TransferOption extends StatelessWidget {
  const TransferOption({
    required this.selected,
    required this.value,
    super.key,
  });

  final bool selected;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? BrandColors.light : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          value,
          style: context.textTheme.bodyMedium!.copyWith(
            color: selected
                ? BrandColors.backgroundColor
                : BrandColors.washedTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
