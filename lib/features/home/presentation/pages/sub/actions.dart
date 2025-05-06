import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/home/presentation/widgets/action_banner.dart';

class ActionTasks extends StatelessWidget {
  const ActionTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        children: [
          ActionBanners(
            title: 'Create your @username',
            subtitle: 'A unique identity for your wallet',
            bannerKey: Strings.createUsername,
            icon: R.ASSETS_ICONS_USERNAME_ICON_SVG,
            onTap: () {
              context.push(pSetUsername);
              HapticFeedback.lightImpact();
            },
          ),
          ActionBanners(
            title: 'Back up your 12 Key-phrase!',
            subtitle: 'Learn more',
            bannerKey: Strings.backupPhrase,
            icon: R.ASSETS_ICONS_SECURITY_LOCK_SVG,
            onTap: () {
              // true: means backup seed phrase
              // false: means just see seed phrase
              context.push(pMnenomicInstruction, extra: true);
              HapticFeedback.lightImpact();
            },
          ),
          ActionBanners(
            title: 'KYC Verification',
            subtitle: 'Unlock more access',
            bannerKey: Strings.kycVerification,
            icon: R.ASSETS_ICONS_KYC_ICON_SVG,
            onTap: () {
              context.push(pKyc);
              HapticFeedback.lightImpact();
            },
          ),
          ActionBanners(
            title: 'Connect your wallet',
            subtitle: 'Unlock full functionality',
            icon: R.ASSETS_ICONS_WALLET_CONNECT_ICON_SVG,
            bannerKey: Strings.connectWallet,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
