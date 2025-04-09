import 'package:flutter/material.dart';
import 'package:guava/const/resource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboard.notifier.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier with ChangeNotifier {
  @override
  OnboardingNotifier build() {
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
      'title': 'Welcome to Guavafi',
      'subtitle': '',
      'background_icon': R.ASSETS_ICONS_ONBOARD_1_SVG,
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
          'ltrb': [null, 30.0, 10.0, null],
        },
        {
          'icon': R.ASSETS_ICONS_NFC_FLOATER_SVG,
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_QR_CODE_FLOATER_SVG,
          'ltrb': [null, null, null, null],
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
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_ACCESS_ANYWHERE_FLOATER_SVG,
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_WORLDWIDE_FLOATER_SVG,
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_SOLANA_FLOATER_SVG,
          'ltrb': [null, null, null, null],
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
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_NO_HDDEN_CHARGE_FLOATER_SVG,
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_LOW_FEES_FLOATER_SVG,
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_RATE_FLOATER_SVG,
          'ltrb': [null, null, null, null],
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
          'ltrb': [null, null, null, null],
        },
        {
          'icon': R.ASSETS_ICONS_SECURITY_FLOATER_SVG,
          'ltrb': [null, null, null, null],
        },
      ]
    }
  ];
}
