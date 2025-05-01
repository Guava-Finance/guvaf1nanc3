import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    required this.icon,
    this.width,
    this.height,
    this.color,
    super.key,
  });

  final String icon;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: width,
      height: height,
      // ignore: deprecated_member_use
      color: color,
      // colorFilter: ColorFilter.mode(
      //   color ?? Colors.transparent,
      //   BlendMode.srcIn,
      // ),
    );
  }
}
