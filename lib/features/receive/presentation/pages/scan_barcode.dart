import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

class ScanBarcode extends ConsumerWidget {
  const ScanBarcode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final walletAsyn = ref.watch(walletAddressProvider);
        final username = ref.read(myUsernameProvider.future);

        return walletAsyn.when(
          data: (data) {
            return Column(
              children: [
                Center(
                  child: Container(
                    decoration: ShapeDecoration(
                      color: BrandColors.containerColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          width: 4,
                          color: BrandColors.textColor.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: PrettyQrView.data(
                      data: data,
                      errorCorrectLevel: QrErrorCorrectLevel.H,
                      decoration: PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(
                          color: BrandColors.textColor,
                        ),
                        quietZone: PrettyQrQuietZone.standart,
                      ),
                    ),
                  ).padHorizontal,
                ),
                24.verticalSpace,
                FutureBuilder(
                  future: username,
                  builder: (context, snapshot) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (snapshot.data != null) ...{
                        Text(
                          snapshot.data ?? '',
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: BrandColors.textColor,
                          ),
                        ),
                        6.verticalSpace,
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                    ClipboardData(text: snapshot.data ?? ''))
                                .then((_) {
                              navkey.currentContext!.notify.addNotification(
                                NotificationTile(
                                  content: 'Username copied successfully...',
                                  duration: 3,
                                ),
                              );
                            });
                          },
                          child: Material(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${snapshot.data ?? ''}@guava',
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: BrandColors.washedTextColor,
                                  ),
                                ),
                                4.horizontalSpace,
                                SvgPicture.asset(
                                  R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG,
                                ),
                              ],
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: data)).then((_) {
                      navkey.currentContext!.notify.addNotification(
                        NotificationTile(
                          content: 'Wallet address copied successfully...',
                          duration: 3,
                        ),
                      );
                    });
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: ShapeDecoration(
                      color: BrandColors.containerColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          color: BrandColors.textColor.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.toMaskedFormat(),
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: BrandColors.washedTextColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        5.horizontalSpace,
                        SvgPicture.asset(R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG)
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                CustomButton(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    SharePlus.instance.share(ShareParams(text: data));
                  },
                  title: 'Share',
                ),
                20.verticalSpace,
              ],
            );
          },
          error: (e, s) => 0.verticalSpace,
          loading: () => CupertinoActivityIndicator(
            color: BrandColors.primary,
            radius: 12.r,
          ),
        );
      },
    );
  }
}
