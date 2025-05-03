import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/avatar.dart';

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
            AppAvatar(),
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
                    text: 'Vwegba',
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
            IconButton(
              onPressed: () {
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
                            // Handle potential errors during tab switching
                            debugPrint('Error switching tabs: $e');
                          }
                        }

                        if (ref.exists(receipentAddressProvider)) {
                          ref.read(receipentAddressProvider.notifier).state =
                              scannedValue;
                        }
                      });
                    }
                  }
                });
              },
              icon: CustomIcon(
                icon: R.ASSETS_ICONS_SCAN_ICON_SVG,
                height: 20.h,
                width: 20.w,
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
