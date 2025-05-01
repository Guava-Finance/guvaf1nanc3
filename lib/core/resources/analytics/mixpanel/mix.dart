import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final mixpanel = Provider<Mixpanel>((ref) => Mixpanel(Env.mixpanelToken));

final mixpanelProvider = Provider<MixPanel>((ref) {
  return MixPanel(mixpanel: ref.watch(mixpanel));
});

class MixPanel {
  MixPanel({
    required this.mixpanel,
  });

  final Mixpanel mixpanel;

  void identify(String email) {
    // tie events to a particular user
    mixpanel.identify(email);
    mixpanel.setUseIpAddressForGeolocation(true);
    FirebaseCrashlytics.instance.setUserIdentifier(email);
  }

  void track(String event, {properties}) {
    mixpanel.track(event, properties: properties);
  }

  void setSuperProp(String email) {
    mixpanel.registerSuperPropertiesOnce({
      'email': email,
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
