import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.radius = 20,
  });

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'MY_PROFILE_PHOTO',
      transitionOnUserGestures: true,
      
      child: Consumer(
        builder: (context, ref, child) {
          final avatarAsync = ref.watch(avatarProvider);

          return avatarAsync.when(
            data: (avatar) {
              return CircleAvatar(
                maxRadius: radius.r,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius.r),
                  child: SvgPicture.network(
                    avatar,
                    width: (radius * 2).w,
                    height: (radius * 2).h,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              );
            },
            error: (e, _) {
              return 0.verticalSpace;
            },
            loading: () {
              return CupertinoActivityIndicator(
                color: BrandColors.primary,
                radius: 12.r,
              );
            },
          );
        },
      ),
    );
  }
}
