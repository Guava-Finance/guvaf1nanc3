import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/account/presentation/pages/mnenomics/backup_complete.dart';
import 'package:guava/features/account/presentation/pages/mnenomics/instruction.dart';
import 'package:guava/features/account/presentation/pages/mnenomics/pin.dart';
import 'package:guava/features/account/presentation/pages/mnenomics/show.dart';
import 'package:guava/features/account/presentation/pages/mnenomics/validation.dart';
import 'package:guava/features/account/presentation/pages/privacy/privacy.dart';
import 'package:guava/features/account/presentation/pages/profile/profile_page.dart';
import 'package:guava/features/account/presentation/pages/settings/settings.dart';
import 'package:guava/features/account/presentation/pages/support/support.dart';
import 'package:guava/features/home/presentation/pages/username/username.dart';

/// Account management related routes
final List<RouteBase> accountRoutes = [
  GoRoute(
    name: Strings.setUsername.pathToName,
    path: Strings.setUsername,
    builder: (context, state) => const SetUsername(),
  ),
  GoRoute(
    name: Strings.mnenomicInstruction.pathToName,
    path: Strings.mnenomicInstruction,
    builder: (context, state) {
      return MnenomicsInstructionsPage(
        isBackUp: (state.extra as bool?) ?? false,
      );
    },
  ),
  GoRoute(
    name: Strings.accessPin.pathToName,
    path: Strings.accessPin,
    builder: (context, state) {
      return AppPinValidation(
        isPhoneLock: (state.extra as bool?) ?? false,
      );
    },
  ),
  GoRoute(
    name: Strings.mnenomicShow.pathToName,
    path: Strings.mnenomicShow,
    builder: (context, state) {
      return ShowMnenomicsPage(
        isBackUp: (state.extra as bool?) ?? false,
      );
    },
  ),
  GoRoute(
    name: Strings.mnenomicValidation.pathToName,
    path: Strings.mnenomicValidation,
    builder: (context, state) => const MnemonicBackupValidationPage(),
  ),
  GoRoute(
    name: Strings.mnenomicBackupComplete.pathToName,
    path: Strings.mnenomicBackupComplete,
    builder: (context, state) => const MnenomicBackupComplete(),
  ),
  GoRoute(
    name: Strings.profilePage.pathToName,
    path: Strings.profilePage,
    builder: (context, state) => const ProfilePage(),
  ),
  GoRoute(
    name: Strings.settingsPage.pathToName,
    path: Strings.settingsPage,
    builder: (context, state) => const SettingsPage(),
  ),
  GoRoute(
    name: Strings.privacyPolicyPage.pathToName,
    path: Strings.privacyPolicyPage,
    builder: (context, state) => const PrivacyPolicyPage(),
  ),
  GoRoute(
    name: Strings.supportPage.pathToName,
    path: Strings.supportPage,
    builder: (context, state) => const SupportPage(),
  ),
];
