
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final avatarAsync = ref.watch(avatarProvider);
    
        return avatarAsync.when(
          data: (avatar) {
            return CircleAvatar(
              child: SvgPicture.network(avatar),
            );
          },
          error: (e, _) {
            return 0.verticalSpace;
          },
          loading: () {
            return CircularProgressIndicator();
          },
        );
      },
    );
  }
}
