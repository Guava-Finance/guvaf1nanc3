import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.title,
    this.trailingWidget,
    this.footerText,
    this.paddingVertical,
    this.onTap,
    this.textColor,
    super.key,
  });

  final String title;
  final Widget? trailingWidget;
  final String? footerText;
  final double? paddingVertical;
  final VoidCallback? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: paddingVertical ?? 2.h,
            ),
            decoration: BoxDecoration(
              color: BrandColors.containerColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: BrandColors.washedTextColor.withValues(alpha: .3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
                Spacer(),
                if (trailingWidget != null) ...{trailingWidget!},
              ],
            ),
          ),
        ),
        if (footerText != null) ...{
          6.verticalSpace,
          Text(
            footerText!,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 10.sp,
              color: BrandColors.washedTextColor,
            ),
          ),
        },
        16.verticalSpace,
      ],
    );
  }
}
