import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class RecieveOption extends StatelessWidget {
  const RecieveOption({
    required this.onChanged,
    required this.selected,
    required this.value,
    super.key,
  });

  final VoidCallback onChanged;
  final bool selected;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? BrandColors.light : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
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
