import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/util/permission.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/avatar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeAppbar extends ConsumerWidget {
  const HomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Showcase(
              key: avatarWidgetKey,
              description:
                  '''Your wallet personality. This can be modified on the accounts session''',
              targetBorderRadius: BorderRadius.circular(30.r),
              child: AppAvatar(),
            ),
            10.horizontalSpace,
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Hey\n',
                    style: context.medium.copyWith(
                      color: BrandColors.selectedNavBarLabel,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    text:
                        '''Good ${ref.read(homeNotifierProvider).getTimeOfDayGreeting}''',
                    style: context.medium.copyWith(
                      color: BrandColors.textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Showcase(
              key: scannerWidgetKey,
              description: 'Scan Solana Payment codes and other wallet code',
              child: IconButton(
                onPressed: () async {
                  final mng = ref.read(permissionManagerProvider);

                  if (await mng.verifyPermission(
                      Permission.camera, AppSettingsType.camera)) {
                    if (context.mounted) {
                      context.push(pScanner).then((v) {
                        if (v != null) {
                          final scannedValue = v.toString();

                          if (navkey.currentContext != null) {
                            navkey.currentContext!.push(
                              pTransfer,
                              extra: scannedValue,
                            );

                            // Safely update provider state after navigation
                            Future.delayed(Durations.medium1, () {
                              if (!ref.exists(activeTabState)) return;

                              final transferTab = ref.read(activeTabState);
                              if (transferTab != 0) {
                                try {
                                  ref.read(transferNotifierProvider).jumpTo(0);
                                } catch (e) {
                                  AppLogger.log('Error switching tabs: $e');
                                }
                              }

                              if (ref.exists(receipentAddressProvider)) {
                                ref
                                    .read(receipentAddressProvider.notifier)
                                    .state = scannedValue;
                              }
                            });
                          }
                        }
                      });
                    }
                  }
                },
                icon: CustomIcon(
                  icon: R.ASSETS_ICONS_SCAN_ICON_SVG,
                  height: 20.h,
                  width: 20.w,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: CustomIcon(
                icon: R.ASSETS_ICONS_NOTIFICATION_ICON_SVG,
                height: 20.h,
                width: 20.w,
              ),
            ),
          ],
        ),
      ],
    ).padHorizontal;
  }
}
