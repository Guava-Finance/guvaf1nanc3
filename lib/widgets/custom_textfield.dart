import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield(
      {required this.controller,
      this.hintText,
      this.preffixIcon,
      this.suffixIcon,
      super.key});

  final String? hintText;
  final Widget? preffixIcon;
  final Widget? suffixIcon;
  final TextEditingController controller;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: BrandColors.textColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              suffixIconConstraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.preffixIcon,
              hintText: widget.hintText,
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
              ),
              border: InputBorder.none,
            ),
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
