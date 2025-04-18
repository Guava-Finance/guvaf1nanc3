import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/address_tile.dart';

class AddressBook extends StatelessWidget {
  const AddressBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(R.ASSETS_ICONS_ADDRESS_BOOK_SVG),
            10.horizontalSpace,
            Text(
              'Address book',
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: BrandColors.washedTextColor,
              ),
            )
          ],
        ),
        10.verticalSpace,
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
            itemCount: 5,
            separatorBuilder: (ctx, i) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(
                color: BrandColors.washedTextColor.withValues(alpha: 0.3),
              ),
            ),
            itemBuilder: (ctx, i) {
              return AddressTile();
            },
          ),
        )
      ],
    ).padHorizontal;
  }
}
