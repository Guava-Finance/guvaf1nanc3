import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

final localAuthProvider = Provider<LocalAuthentication>((ref) {
  return LocalAuthentication();
});

final biometricProvider = Provider<BiometricService>((ref) {
  return BiometricService(
    authentication: ref.watch(localAuthProvider),
    storageService: ref.watch(securedStorageServiceProvider),
  );
});

class BiometricService {
  BiometricService({
    required this.authentication,
    required this.storageService,
  });

  final LocalAuthentication authentication;
  final SecuredStorageService storageService;

  Future<bool> hasDeviceSupport() {
    return authentication.canCheckBiometrics;
  }

  Future<bool> isDeviceBiometricEnabled() async {
    final biometrics = await authentication.getAvailableBiometrics();

    return (biometrics.contains(BiometricType.strong) ||
        biometrics.contains(BiometricType.face) ||
        biometrics.contains(BiometricType.iris) ||
        biometrics.contains(BiometricType.fingerprint));
  }

  Future<bool> isAppBiometricEnabled() async {
    final result = await storageService.readFromStorage(Strings.biometric);

    return (result ?? '').isNotEmpty;
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await authentication.authenticate(
        localizedReason: 'Please authenticate access wallet',
        options: AuthenticationOptions(),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      FirebaseCrashlytics.instance.log(e.code);

      if (e.code == auth_error.notAvailable) {
        AppLogger.log('device not supported');
      } else if (e.code == auth_error.notEnrolled) {
        AppLogger.log('Not enrolled');
      } else {
        // ...
      }

      return false;
    }
  }
}
