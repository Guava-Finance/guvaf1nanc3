import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';

class CustomListPicker extends ConsumerStatefulWidget {
  const CustomListPicker({
    required this.options,
    this.onTap,
    this.title,
    super.key,
  });

  final List<String> options;
  final Function(String)? onTap;
  final String? title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomListPickerState();
}

class _CustomListPickerState extends ConsumerState<CustomListPicker> {
  int selected = -1;

  List<String> optionsCopies = [];

  @override
  void initState() {
    super.initState();

    optionsCopies = [...widget.options];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                80.verticalSpace,
                for (var i = 0; i < optionsCopies.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() => selected = i);

                      Future.delayed(Durations.medium2, () {
                        navkey.currentContext!.pop();
                        widget.onTap?.call(optionsCopies[i]);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        color: selected == i
                            ? BrandColors.washedTextColor.withValues(alpha: .1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        optionsCopies[i],
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                context.mediaQuery.viewInsets.bottom.verticalSpace,
                30.verticalSpace,
              ],
            ).padHorizontal,
          ),
        ),
        Positioned(
          left: 0.w,
          right: 0.w,
          child: Container(
            decoration: BoxDecoration(color: BrandColors.backgroundColor),
            padding: EdgeInsets.only(bottom: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title ?? 'Select Option',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
                12.verticalSpace,
                SizedBox(
                  height: 36.h,
                  child: TextField(
                    onChanged: (value) {
                      optionsCopies = [...widget.options];
                      optionsCopies.retainWhere((e) => e.contains(value));

                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: BrandColors.light.withValues(alpha: .1),
                      filled: true,
                      hintText: 'Search',
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        color: BrandColors.washedTextColor,
                      ),
                    ),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      color: BrandColors.textColor,
                    ),
                  ).padHorizontal,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
