import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: BrandColors.textColor,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: BrandColors.washedTextColor,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
