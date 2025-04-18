import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/styles/colors.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          maxRadius: 20.r,
          backgroundColor: BrandColors.lightGreen,
          child: Center(
            child: Text(
              'MF',
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: BrandColors.backgroundColor,
              ),
            ),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@moneymanforever',
                style: context.medium.copyWith(
                  color: BrandColors.light,
                  fontSize: 14.sp,
                ),
              ),
              5.verticalSpace,
              Text(
                '9Cu6uYFinFz6wd3iJPoPvTiTVsgxnKzZNhgkbJXnAaP1'.toMaskedFormat(),
                style: context.medium.copyWith(
                  color: BrandColors.washedTextColor,
                  fontSize: 12.w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
