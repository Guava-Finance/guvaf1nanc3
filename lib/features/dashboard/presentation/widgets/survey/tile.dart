import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';

class SurveyTile extends StatelessWidget {
  const SurveyTile({
    required this.title,
    this.description,
    this.isActive = false,
    this.onTap,
    super.key,
  });

  final bool isActive;
  final String title;
  final String? description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: description ?? title,
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? context.theme.colorScheme.primary
                : context.theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: isActive
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.primary.withAlpha(50),
              width: 2,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 24.w,
          ),
          child: Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: isActive
                  ? context.theme.colorScheme.onPrimary
                  : context.theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
