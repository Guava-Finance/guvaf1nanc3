import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    required this.controller,
    this.hintText,
    this.preffixIcon,
    this.suffixIcon,
    this.label,
    this.onChanged,
    this.capitalization,
    this.validator,
    this.inputFormatters,
    this.readOnly = false,
    super.key,
  });

  final String? hintText;
  final Widget? preffixIcon;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? label;
  final Function(String?)? onChanged;
  final TextCapitalization? capitalization;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...{
          Text(
            widget.label!,
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.washedTextColor,
              fontSize: 12.sp,
            ),
          ),
          4.verticalSpace,
        },
        Container(
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
                readOnly: widget.readOnly,
                controller: widget.controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: widget.onChanged,
                textCapitalization:
                    widget.capitalization ?? TextCapitalization.none,
                validator: widget.validator,
                inputFormatters: widget.inputFormatters,
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
                  errorStyle: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 10.sp,
                    color: BrandColors.washedRed,
                  ),
                  border: InputBorder.none,
                ),
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
