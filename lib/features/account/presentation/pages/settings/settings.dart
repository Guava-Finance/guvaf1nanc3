import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/widgets/setting.tile.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ref
        .read(firebaseAnalyticsProvider)
        .triggerScreenLogged(runtimeType.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.verticalSpace,
          SettingTile(
            title: 'Allow notifications',
            footerText:
                'Notifications may include alerts, sounds and icon badges',
            trailingWidget: Switch.adaptive(
              padding: EdgeInsets.zero,
              activeColor: BrandColors.washedYellow,
              value: true,
              onChanged: (_) {},
            ),
          ),
          SettingTile(
            title: 'Currency',
            footerText:
                '''Changing the currency will affect how you see your transactions''',
            paddingVertical: 16.h,
            trailingWidget: Text(
              'NGN',
              style: context.textTheme.bodyMedium,
            ),
          ),
          SettingTile(
            title: 'Language',
            footerText: 'Change the default language',
            paddingVertical: 16.h,
            trailingWidget: Text(
              'English',
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ).padHorizontal,
    );
  }
}
