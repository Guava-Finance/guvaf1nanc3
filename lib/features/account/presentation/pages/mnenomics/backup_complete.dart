import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/widgets/app_icon.dart';

class MnenomicBackupComplete extends ConsumerWidget {
  const MnenomicBackupComplete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Backup')),
      body: Column(
        children: [
          24.verticalSpace,
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CustomIcon(
              icon: R.ASSETS_ICONS_CHECKMARK_SVG,
              width: 20.w,
              height: 20.h,
            ),
          ),
        ],
      ).padHorizontal,
    );
  }
}
