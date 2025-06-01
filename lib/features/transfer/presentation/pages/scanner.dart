import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/scanner_result.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/usecases/solana_pay.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class WalletScannerPage extends ConsumerStatefulWidget {
  const WalletScannerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletScannerPageState();
}

class _WalletScannerPageState extends ConsumerState<WalletScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref
        .read(firebaseAnalyticsProvider)
        .triggerScreenLogged(runtimeType.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            formatsAllowed: [
              BarcodeFormat.qrcode,
            ],
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: BrandColors.primary,
              borderRadius: 10.r,
              borderWidth: 6.w,
              overlayColor: BrandColors.backgroundColor.withValues(alpha: .6),
            ),
          ),
        ],
      ),
    );
  }

  int scanResult = 0;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      scanResult++;

      controller.pauseCamera();

      if (scanResult == 1) {
        HapticFeedback.lightImpact();

        if (scanData.code.parseSolanaPayUrl != null) {
          // trigger solana pay
          ref.watch(solanaPayParam.notifier).state =
              scanData.code.parseSolanaPayUrl;
          navkey.currentContext!.push(pSolanaPayReview);

          navkey.currentContext!.mixpanel.timetrack(
            MixpanelEvents.sendViaSolanaPay,
          );

          return;
        }

        if (scanData.code.parseWalletAddress != null) {
          // follows normal wallet transfer flow
          navkey.currentContext!.pop(scanData.code);

          navkey.currentContext!.mixpanel.timetrack(
            MixpanelEvents.sendViaWallet,
          );

          return;
        }

        navkey.currentContext!.pop();
        navkey.currentContext!.notify.addNotification(
          NotificationTile(
            content: 'Invalid QRCode',
            notificationType: NotificationType.warning,
            duration: 2,
          ),
        );
      }
    });
  }
}
