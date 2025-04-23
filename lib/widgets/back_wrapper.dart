import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';

class BackWrapper extends StatefulWidget {
  const BackWrapper(
      {required this.title,
      required this.child,
      this.trailing,
      this.onBackPressed,
      this.hasBackButton = true,
      super.key});

  final String title;
  final Widget? trailing;
  final Function? onBackPressed;
  final bool? hasBackButton;
  final Widget child;

  @override
  State<BackWrapper> createState() => _BackWrapperState();
}

class _BackWrapperState extends State<BackWrapper> {
  late bool canPop;

  @override
  void initState() {
    super.initState();
    canPop = context.canPop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 12.h,
              left: 0,
              right: 0,
              child: Text(
                widget.title,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: BrandColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            widget.trailing != null
                ? Positioned(
                    top: 12.h,
                    right: 0,
                    child: widget.trailing!.padHorizontal,
                  )
                : SizedBox.shrink(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.hasBackButton ?? false)
                      canPop
                          ? GestureDetector(
                              onTap: () {
                                widget.onBackPressed == null
                                    ? context.pop()
                                    : widget.onBackPressed!();
                              },
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: BrandColors.containerColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: SvgPicture.asset(
                                      R.ASSETS_ICONS_CLOSE_SVG),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                  ],
                ),
                15.verticalSpace,
                Expanded(child: widget.child),
                30.verticalSpace,
              ],
            ).padHorizontal,
          ],
        ),
      ),
    );
  }
}
