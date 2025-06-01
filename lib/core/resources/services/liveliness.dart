import 'package:flutter/cupertino.dart';
import 'package:flutter_dojah_kyc/flutter_dojah_kyc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/routes/router.dart';

final livelinessServiceProvider = Provider<LivelinessService>((ref) {
  return LivelinessService();
});

class LivelinessService {
  DojahKYC? _dojahKYC;

  Future<void> initKyc({
    required String walletAddress,
    Function(dynamic)? onSuccess,
    Function(dynamic)? onError,
    Function(dynamic)? onClose,
  }) async {
    final BuildContext context = navkey.currentState!.context;

    context.mixpanel.track(MixpanelEvents.kycStarted, properties: {
      'KYC Partner': 'Dojah.io',
    });
    context.mixpanel.timetrack(MixpanelEvents.kycSubmitted);

    _dojahKYC = DojahKYC(
      appId: Env.dojahApiId,
      publicKey: Env.dojahPublicKey,
      type: 'custom',
      userData: {
        'user_id': walletAddress,
      },
      metaData: {
        'user_id': walletAddress,
      },
      config: {
        'widget_id': Env.dojahWidgetId,
      },
    );

    await _dojahKYC?.open(
      context,
      onSuccess: (result) {
        /// after a successful kyc session close the Dojah widget
        context.nav.pop();

        /// use to carry out extra functionality on success of the KYC
        onSuccess?.call(result);
      },
      onClose: (close) {
        onClose?.call(close);
      },
      onError: (error) {
        /// call the notification tile widget to display the error to the user
        //  context.notify.addNotification();

        /// this is used to carry out extra functions during an error
        onError?.call(error);
      },
    );
  }
}
