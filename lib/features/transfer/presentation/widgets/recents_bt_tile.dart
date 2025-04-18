import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class RecentsBankTransferTile extends StatelessWidget {
  const RecentsBankTransferTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(R.ASSETS_IMAGES_NGN_TRANS_PNG, height: 40.h),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Akubueze David',
                style: context.medium.copyWith(
                  color: BrandColors.light,
                  fontSize: 14.sp,
                ),
              ),
              5.verticalSpace,
              Text(
                '9024076853 (United Bank of Africa)',
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
