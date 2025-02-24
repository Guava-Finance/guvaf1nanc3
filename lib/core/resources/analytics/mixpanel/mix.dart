import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

@lazySingleton
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

  void log(String event, {properties}) {
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
