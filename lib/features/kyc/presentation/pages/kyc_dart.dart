import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/liveliness.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/resources/util/permission.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

class KycPage extends ConsumerStatefulWidget {
  const KycPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycPageState();
}

class _KycPageState extends ConsumerState<KycPage> with Loader {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let\'s Verify KYC'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          8.verticalSpace,
          Text(
            'Please submit the following documents to\nverify your profile',
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.washedTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          CustomIcon(
            icon: R.ASSETS_ICONS_KYC_HOME_SVG,
            width: 264.w,
            height: 264.h,
          ),
          40.verticalSpace,
          ListTile(
            leading: CustomIcon(icon: R.ASSETS_ICONS_CONTACT_CARD_SVG),
            title: Text(
              'Take a picture of your valid ID',
              style: context.textTheme.bodyLarge?.copyWith(
                color: BrandColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'To check if your personal information are correct',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
                fontSize: 12.sp,
              ),
            ),
          ),
          10.verticalSpace,
          ListTile(
            leading: CustomIcon(icon: R.ASSETS_ICONS_CAMERA_OUTLINED_SVG),
            title: Text(
              'Take a selfie of yourself',
              style: context.textTheme.bodyLarge?.copyWith(
                color: BrandColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'To match your face to your ID photos',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ).padHorizontal,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onTap: () async => startKYC(),
            title: 'Get started',
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }

  void startKYC() async {
    final mng = ref.read(permissionManagerProvider);

    if (await mng.verifyPermission(Permission.camera, AppSettingsType.camera)) {
      if (await mng.verifyPermission(Permission.mediaLibrary)) {
        if (await mng.verifyPermission(Permission.microphone)) {
          if (await mng.verifyPermission(Permission.photos)) {
            final wallet = await ref.read(walletAddressProvider.future);
            ref.read(livelinessServiceProvider).initKyc(
                  walletAddress: wallet,
                  onSuccess: (p0) {
                    navkey.currentContext!.notify.addNotification(
                      NotificationTile(
                        notificationType: NotificationType.success,
                        title: 'KYC Success',
                        content: 'Please wait while we verify your documents',
                      ),
                    );

                    context.go(pKycDone);
                  },
                  onError: (p0) {
                    navkey.currentContext!.notify.addNotification(
                      NotificationTile(
                        notificationType: NotificationType.error,
                        title: 'KYC Failed',
                        content: p0.toString(),
                      ),
                    );
                  },
                  onClose: (p0) {
                    navkey.currentContext!.notify.addNotification(
                      NotificationTile(
                        notificationType: NotificationType.information,
                        title: 'KYC Closed',
                        content: p0.toString(),
                      ),
                    );
                  },
                );
          }
        }
      }
    }
  }
}
