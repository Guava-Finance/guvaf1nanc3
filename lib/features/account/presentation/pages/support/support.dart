import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/notifier/account.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  @override
  Widget build(BuildContext context) {
    // final an = ref.watch(accountNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Support')),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.verticalSpace,
            CircleAvatar(
              maxRadius: 30.r,
              backgroundColor: BrandColors.textColor,
              child: Text(
                'S',
                style: context.textTheme.headlineLarge?.copyWith(
                  color: BrandColors.backgroundColor,
                ),
              ),
            ),
            12.verticalSpace,
            Text(
              'Hey there!\nHow can we help you?',
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.5.h,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            32.verticalSpace,
            Text(
              'Support',
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: BrandColors.washedTextColor,
              ),
            ),
            8.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 24.w,
              ),
              decoration: ShapeDecoration(
                color: BrandColors.containerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      try {
                        launchUrl(
                          Uri.parse(
                            'https://tawk.to/chat/6824d5ccdc0e5b190bdd2a22/1ir7u6a9u',
                          ),
                          mode: LaunchMode.inAppWebView,
                          browserConfiguration: BrowserConfiguration(
                            showTitle: false,
                          ),
                          webViewConfiguration: WebViewConfiguration(
                            enableJavaScript: true,
                            enableDomStorage: true,
                            headers: {},
                          ),
                        );
                      } catch (e) {
                        AppLogger.log(e);
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Chat',
                      style: context.medium.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 14.w,
                      ),
                    ),
                    trailing: CustomIcon(
                      icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                    ),
                  ),
                  Divider(
                    color: BrandColors.textColor.withValues(alpha: 0.1),
                  ),
                  ListTile(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      launchUrl(
                        Uri.parse('https://tally.so/r/wzOPbk'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    trailing: CustomIcon(
                      icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                    ),
                    title: Text(
                      'Share feedback',
                      style: context.medium.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 14.w,
                      ),
                    ),
                  ),
                  Divider(
                    color: BrandColors.textColor.withValues(alpha: 0.1),
                  ),
                  ListTile(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      launchUrl(
                        Uri.parse('https://guava.finance'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    trailing: CustomIcon(
                      icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                    ),
                    title: Text(
                      'View help articles',
                      style: context.medium.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 14.w,
                      ),
                    ),
                  ),
                  Divider(
                    color: BrandColors.textColor.withValues(alpha: 0.1),
                  ),
                  ListTile(
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                    contentPadding: EdgeInsets.zero,
                    trailing: CustomIcon(
                      icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                    ),
                    title: Text(
                      'Destroy wallet',
                      style: context.medium.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 14.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            32.verticalSpace,
            Text(
              'Troubleshoot: Share your data with the support team',
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: BrandColors.washedTextColor,
              ),
            ),
            8.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 24.w,
              ),
              decoration: ShapeDecoration(
                color: BrandColors.containerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Send payment activity',
                      style: context.medium.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 14.w,
                      ),
                    ),
                    trailing: CustomIcon(
                      icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                    ),
                  ),
                  Divider(
                    color: BrandColors.textColor.withValues(alpha: 0.1),
                  ),
                  ListTile(
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                    contentPadding: EdgeInsets.zero,
                    trailing: CustomIcon(
                      icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                    ),
                    title: Text(
                      'Send app activity',
                      style: context.medium.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 14.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            60.verticalSpace,
          ],
        ).padHorizontal,
      ),
    );
  }
}
