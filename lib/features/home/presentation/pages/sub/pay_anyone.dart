import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';

class PayAnyone extends ConsumerStatefulWidget {
  const PayAnyone({
    super.key,
  });

  @override
  ConsumerState<PayAnyone> createState() => _PayAnyoneState();
}

class _PayAnyoneState extends ConsumerState<PayAnyone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 20.w,
      ),
      decoration: ShapeDecoration(
        color: BrandColors.containerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}
