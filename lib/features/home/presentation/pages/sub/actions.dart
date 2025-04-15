
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/app_strings.dart';
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
            title: 'Connect your wallet',
            subtitle: 'Unlock full functionality',
            icon: R.ASSETS_ICONS_WALLET_CONNECT_ICON_SVG,
            bannerKey: Strings.connectWallet,
            onTap: () {},
          ),
          ActionBanners(
            title: 'Create your @username',
            subtitle: 'A unique identity for your wallet',
            bannerKey: Strings.createUsername,
            icon: R.ASSETS_ICONS_USERNAME_ICON_SVG,
          ),
          ActionBanners(
            title: 'Back up your 12 Key-phrase!',
            subtitle: 'Learn more',
            bannerKey: Strings.backupPhrase,
            icon: R.ASSETS_ICONS_SECURITY_LOCK_SVG,
          ),
          ActionBanners(
            title: 'KYC Verification',
            subtitle: 'Unlock more access',
            bannerKey: Strings.kycVerification,
            icon: R.ASSETS_ICONS_KYC_ICON_SVG,
          ),
    
          // Image.asset(
          //   R.ASSETS_IMAGES_HOME_SLIDER1_PNG,
          //   height: 100.h,
          // ),
          // Image.asset(
          //   R.ASSETS_IMAGES_HOME_SLIDER2_PNG,
          //   height: 100.h,
          // ),
          // Image.asset(
          //   R.ASSETS_IMAGES_HOME_SLIDER3_PNG,
          //   height: 100.h,
          // ),
          // Image.asset(
          //   R.ASSETS_IMAGES_HOME_SLIDER4_PNG,
          //   height: 100.h,
          // ),
        ],
      ),
    );
  }
}
