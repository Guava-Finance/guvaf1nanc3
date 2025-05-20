import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final mixpanel = FutureProvider<Mixpanel>(
  (ref) async => await Mixpanel.init(
    Env.mixpanelToken,
    trackAutomaticEvents: true,
  ),
);

final mixpanelProvider = Provider<MixPanel>((ref) {
  return MixPanel();
});

// final mixpanelProvider = Provider<MixPanel>((ref) {
//   final mixpanelAsync = ref.watch(mixpanel);

//   return mixpanelAsync.maybeWhen(
//     data: (mixpanel) => MixPanel(mixpanel: mixpanel),
//     orElse: () => throw Exception('Mixpanel not initialized'),
//   );
// });

class MixPanel {
  MixPanel();

  late Mixpanel mixpanel;

  bool isMixpanelInitialized = false;

  Future<void> init() async {
    if (!isMixpanelInitialized) {
      mixpanel = await Mixpanel.init(
        Env.mixpanelToken,
        trackAutomaticEvents: true,
      );

      isMixpanelInitialized = true;
    }
  }

  void identify(String walletAddress) {
    // tie events to a particular user
    mixpanel.identify(walletAddress);
    mixpanel.setUseIpAddressForGeolocation(true);
    FirebaseCrashlytics.instance.setUserIdentifier(walletAddress);
  }

  void track(String event, {properties}) {
    mixpanel.track(event, properties: properties);
  }

  void timetrack(String event) {
    mixpanel.timeEvent(event);
  }

  void setSuperProp(String walletAddress) {
    mixpanel.registerSuperPropertiesOnce({
      'Wallet Address': walletAddress,
    });
  }

  void unregisterSuperProp() {
    mixpanel.clearSuperProperties();
    // clears identity
    mixpanel.reset();
  }

  void valueOurUsers(double amount, time) {
    mixpanel.getPeople().trackCharge(amount, properties: time);
  }
}
