import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/home/presentation/widgets/icon_button.dart';
import 'package:showcaseview/showcaseview.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 20.w,
      ),
      decoration: ShapeDecoration(
        color: BrandColors.containerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Showcase(
            key: transferWidgetKey,
            description: 'Send money to other wallets, banks and across border',
            targetPadding: EdgeInsets.all(12.sp),
            child: CircularIconButton(
              action: 'Send',
              icon: R.ASSETS_ICONS_TRANSFER_ICON_SVG,
              color: BrandColors.washedRed,
              onTap: () {
                context.push(pTransfer);
                HapticFeedback.lightImpact();
              },
            ),
          ),
          Showcase(
            key: receiveWidgetKey,
            description:
                'Receive money from other banks, wallet and across border',
            targetPadding: EdgeInsets.all(12.sp),
            child: CircularIconButton(
              action: 'Receive',
              icon: R.ASSETS_ICONS_RECIEVE_ICON_SVG,
              color: BrandColors.washedGreen,
              onTap: () {
                // context.push(pRecieve);
                // HapticFeedback.lightImpact();

                context.notify.addNotification(
                  NotificationTile(
                    content: 'On-ramp is currently unavailable',
                  ),
                );
              },
            ),
          ),
          CircularIconButton(
            action: 'Guava Pay',
            icon: R.ASSETS_ICONS_WALLET_ICON_SVG,
            color: BrandColors.washedBlue,
          ),
        ],
      ),
    ).padHorizontal;
  }
}
