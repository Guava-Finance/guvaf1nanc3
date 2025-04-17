import 'package:flutter/material.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/features/onboarding/domain/usecases/create_a_wallet.dart';
import 'package:guava/features/onboarding/domain/usecases/restore_a_wallet_mnemonics.dart';
import 'package:guava/features/onboarding/domain/usecases/restore_a_wallet_pk.dart';
import 'package:hashlib/hashlib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboard.notifier.g.dart';

final isAccessPinSetProovider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(securedStorageServiceProvider);

  return await storage.doesExistInStorage(Strings.accessCode);
});

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier with ChangeNotifier {
  @override
  OnboardingNotifier build() {
    /// initialize usecases here

    _slideIndex = 0;
    // Initialize any state variables here
    // For example, you might want to track whether the user has completed onboarding
    // or store the current page index in a PageView.
    // Example:
    // _currentPageIndex = 0;
    return this;
  }

  late int _slideIndex;

  int get slideIndex => _slideIndex;

  set slideIndex(int index) {
    _slideIndex = index;

    notifyListeners();
  }

  List<dynamic> slides = [
    {
      'title': 'Welcome to Guava',
      'subtitle': '',
      'background_icon': '',
      'sub_icons_n_positions': []
    },
    {
      'title': 'Instant Transactions',
      'subtitle':
          '''Instantly convert fiat to crypto and vice versa within\nseconds, enabling quick access to funds without\ndelays.''',
      'background_icon': R.ASSETS_ICONS_ONBOARD_1_SVG,
      'sub_icons_n_positions': [
        {
          'icon': R.ASSETS_ICONS_WALLET_TO_WALLET_FLOATER_SVG,
          'ltrb': [null, 70.0, 15.0, null],
        },
        {
          'icon': R.ASSETS_ICONS_NFC_FLOATER_SVG,
          'ltrb': [null, null, 30.0, 180.0],
        },
        {
          'icon': R.ASSETS_ICONS_QR_CODE_FLOATER_SVG,
          'ltrb': [35.0, null, null, 100.0],
        },
        {
          'icon': R.ASSETS_ICONS_SWAP_FLOATER_SVG,
          'ltrb': [150.0, 200.0, null, null],
        },
      ]
    },
    {
      'title': 'Global Accessibility',
      'subtitle':
          '''Manage your finance from anywhere, enabling\nborderless transactions without relying on traditional\nbanks.''',
      'background_icon': R.ASSETS_ICONS_ONBOARD_2_SVG,
      'sub_icons_n_positions': [
        {
          'icon': R.ASSETS_ICONS_NO_LIMIT_FLOATER_SVG,
          'ltrb': [35.0, 100.0, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_ACCESS_ANYWHERE_FLOATER_SVG,
          'ltrb': [null, 130.0, 35.0, null],
        },
        {
          'icon': R.ASSETS_ICONS_WORLDWIDE_FLOATER_SVG,
          'ltrb': [60.0, null, null, 75.0],
        },
        {
          'icon': R.ASSETS_ICONS_SOLANA_FLOATER_SVG,
          'ltrb': [null, null, 45.0, 70.0],
        },
      ]
    },
    {
      'title': 'Low fees, High convenience',
      'subtitle':
          '''Say goodbye to hidden charges. Enjoy secure and\naffordable transactions.''',
      'background_icon': R.ASSETS_ICONS_ONBOARD_3_SVG,
      'sub_icons_n_positions': [
        {
          'icon': R.ASSETS_ICONS_FAST_TRANSFER_FLOATER_SVG,
          'ltrb': [null, 200.0, 40.0, null],
        },
        {
          'icon': R.ASSETS_ICONS_NO_HDDEN_CHARGE_FLOATER_SVG,
          'ltrb': [60.0, null, null, 140.0],
        },
        {
          'icon': R.ASSETS_ICONS_LOW_FEES_FLOATER_SVG,
          'ltrb': [null, null, 70.0, 55.0],
        },
        {
          'icon': R.ASSETS_ICONS_RATE_FLOATER_SVG,
          'ltrb': [null, 90.0, 120.0, null],
        },
      ]
    },
    {
      'title': 'Your wallet, Your control',
      'subtitle':
          '''Manage your finance safely with intuitive tools and\ninstant notifications.''',
      'background_icon': R.ASSETS_ICONS_ONBOARD_4_SVG,
      'sub_icons_n_positions': [
        {
          'icon': R.ASSETS_ICONS_YOUR_CONTROL_SVG,
          'ltrb': [null, null, 35.0, 220.0],
        },
        {
          'icon': R.ASSETS_ICONS_SECURITY_FLOATER_SVG,
          'ltrb': [null, null, 100.0, 50.0],
        },
      ]
    }
  ];

  Future<AppState> createAWallet() async {
    final result = await ref.read(createAWalletUsecaseProvider).call(
          params: null,
        );

    if (result.isError) {
      // todo: show notification
      AppLogger.log('Throwing notification');
    }

    return result;
  }

  String accessPin = '';

  Future<void> savedAccessPin() async {
    // gets the HashDigest and saved the base64 format
    final pin = sha256.string(accessPin);

    await ref.read(securedStorageServiceProvider).writeToStorage(
          key: Strings.accessCode,
          value: pin.base64(),
        );
  }

  Future<AppState> restoreAWallet(String mnemonic) async {
    final result = await ref
        .read(restoreAWalletMnemonicsUsecaseProvider)
        .call(params: mnemonic);

    if (result.isError) {
      // todo: show notification
      AppLogger.log('Throwing mnemonic notification');
    }

    return result;
  }

  Future<AppState> restoreAWalletPK(String privateKey) async {
    final result = await ref
        .read(restoreAWalletPKUsecaseProvider)
        .call(params: privateKey);

    if (result.isError) {
      // todo: show notification
      AppLogger.log('Throwing pk notification');
    }

    return result;
  }
}
