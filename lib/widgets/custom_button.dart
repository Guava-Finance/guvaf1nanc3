import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/utility_widget.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final Function onTap;
  final bool filled;
  final bool disable;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;
  final EdgeInsets? padding;
  final double? radius;
  final double? height;
  final Widget? child;
  final bool showBorder;
  final TextStyle? textStyle;

  const CustomButton(
      {required this.onTap,
      super.key,
      this.title,
      this.filled = true,
      this.backgroundColor,
      this.textColor,
      this.textSize,
      this.disable = false,
      this.padding,
      this.radius,
      this.height,
      this.child,
      this.showBorder = false,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(radius ?? 15.r),
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (!disable) {
            HapticFeedback.mediumImpact();
            onTap();
          }
        },
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: height != null
              ? EdgeInsets.zero
              : padding ??
                  EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
          width: double.infinity,
          height: 42.h,
          decoration: BoxDecoration(
              color: disable
                  ? Color(0xFF979797)
                  : filled
                      ? (backgroundColor ?? BrandColors.primary)
                      : null,
              border: !disable
                  ? showBorder
                      ? Border.all(
                          color: backgroundColor ?? const Color(0xFFe2e8f0))
                      : null
                  : Border.all(
                      color: disable
                          ? Colors.transparent
                          : (backgroundColor ?? const Color(0xFF011B55))),
              borderRadius: BorderRadius.circular(radius ?? 50.r)),
          child: Center(
            child: child ??
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$title',
                    style: textStyle ??
                        context.semiBold.copyWith(
                            fontSize: textSize ?? 14.sp,
                            color: textColor ?? hexColor('#28443F'),
                            height: 1.875),
                    textAlign: TextAlign.center,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
