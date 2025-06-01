import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/services/auth.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/widgets/setting.tile.dart';
import 'package:guava/widgets/app_icon.dart';

class PrivacyPolicyPage extends ConsumerStatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends ConsumerState<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    ref
        .read(firebaseAnalyticsProvider)
        .triggerScreenLogged(runtimeType.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy & security'),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.verticalSpace,
            SettingTile(
              title: 'Updates and news',
              footerText: 'Recieve product news and updates',
              trailingWidget: Switch.adaptive(
                padding: EdgeInsets.zero,
                activeColor: BrandColors.washedYellow,
                value: true,
                onChanged: (_) {},
              ),
            ),
            SettingTile(
              title: 'Discover phone number',
              footerText: 'Make your account visible with your phone number',
              trailingWidget: Switch.adaptive(
                padding: EdgeInsets.zero,
                activeColor: BrandColors.washedYellow,
                value: true,
                onChanged: (_) {},
              ),
            ),
            SettingTile(
              title: 'App analytics',
              footerText: 'Allow analytics of usage and data from your account',
              trailingWidget: Switch.adaptive(
                padding: EdgeInsets.zero,
                activeColor: BrandColors.washedYellow,
                value: true,
                onChanged: (_) {},
              ),
            ),
            12.verticalSpace,
            Text(
              'Security',
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 10.sp,
              ),
            ),
            12.verticalSpace,
            Consumer(
              builder: (context, ref, child) {
                final biometric = ref.watch(biometricProvider);

                return FutureBuilder(
                  future: biometric.isAppBiometricEnabled(),
                  builder: (_, ss) {
                    return SettingTile(
                      title: 'Use biometrics',
                      footerText:
                          '''Enable biometric authentication to transfer funds.''',
                      trailingWidget: Switch.adaptive(
                        activeColor: BrandColors.washedYellow,
                        padding: EdgeInsets.zero,
                        value: ss.data ?? false,
                        onChanged: (_) async {
                          biometric.authenticate().then((v) async {
                            if (ss.data!) {
                              await biometric.disableBiometric();
                              ref.invalidate(biometricProvider);
                            } else {
                              if (v) {
                                await biometric.enableBiometric();
                                ref.invalidate(biometricProvider);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
            SettingTile(
              onTap: () {
                HapticFeedback.lightImpact();
                context.push(pMnenomicInstruction);
              },
              title: 'Secret phrase',
              footerText: '''View secret phrase needed to re-enter account''',
              paddingVertical: 16.h,
              trailingWidget: CustomIcon(
                icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
              ),
            ),
            SettingTile(
              onTap: () {
                HapticFeedback.lightImpact();
                context.push(pSetupPin);
              },
              title: 'Change pin',
              footerText: '''Change PIN code''',
              paddingVertical: 16.h,
              trailingWidget: CustomIcon(
                icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
              ),
            ),
            SettingTile(
              title: 'Delete Google Cloud backup',
              footerText: 'Backup your secret phrase to the cloud',
              paddingVertical: 16.h,
              textColor: BrandColors.red,
              trailingWidget: Icon(
                CupertinoIcons.delete,
                color: BrandColors.red,
              ),
            ),
            40.verticalSpace,
          ],
        ).padHorizontal,
      ),
    );
  }
}
