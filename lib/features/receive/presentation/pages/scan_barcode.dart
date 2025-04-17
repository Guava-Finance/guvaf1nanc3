import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/custom_button.dart';

class ScanBarcode extends ConsumerWidget {
  const ScanBarcode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: ShapeDecoration(
              color: BrandColors.containerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(
                  width: 4,
                  color: BrandColors.textColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Image.asset(R.ASSETS_IMAGES_BARCODE_PNG, height: 270.w),
          ),
        ),
        10.verticalSpace,
        Text(
          'oghenevwegba05',
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: BrandColors.textColor,
          ),
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'wallet.guavafi/oghenevwegba05',
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: BrandColors.washedTextColor,
              ),
            ),
            3.horizontalSpace,
            SvgPicture.asset(R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG),
          ],
        ),
        Spacer(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: ShapeDecoration(
            color: BrandColors.containerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: BrandColors.textColor.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UFQTYEUDJjdhdhjdBfSs'.toMaskedFormat(),
                style: context.textTheme.bodyMedium!.copyWith(
                  color: BrandColors.washedTextColor,
                  fontSize: 12.sp,
                ),
              ),
              5.horizontalSpace,
              SvgPicture.asset(R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG)
            ],
          ),
        ),
        10.verticalSpace,
        CustomButton(onTap: () {}, title: 'Share')
      ],
    );
  }
}
