import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/widgets/avatar.dart';
import 'package:guava/widgets/custom_textfield.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
        .read(firebaseAnalyticsProvider)
        .triggerScreenLogged(runtimeType.toString());

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          12.verticalSpace,
          AppAvatar(radius: 30),
          24.verticalSpace,
          CustomTextfield(
            height: 0,
            controller: TextEditingController(),
            label: 'Username',
            readOnly: true,
          ),
          12.verticalSpace,
          CustomTextfield(
            height: 0,
            controller: TextEditingController(),
            label: 'Full name',
            readOnly: true,
          ),
          12.verticalSpace,
          CustomTextfield(
            height: 0,
            controller: TextEditingController(),
            label: 'Recovery email',
            readOnly: true,
          ),
          12.verticalSpace,
          CustomTextfield(
            height: 0,
            controller: TextEditingController(),
            label: 'Phone',
            readOnly: true,
          ),
        ],
      ).padHorizontal,
    );
  }
}
