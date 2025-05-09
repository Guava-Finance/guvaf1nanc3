import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/state.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/entities/transaction_history.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/domain/usecases/check_username.dart';
import 'package:guava/features/home/domain/usecases/set_username.dart';
import 'package:guava/features/home/presentation/widgets/action_banner.dart';
import 'package:guava/features/onboarding/data/models/account.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home.notifier.g.dart';

final isBalanceVisibleProvider = StateProvider<bool>((ref) {
  return false;
});

final isUsernameAvailableProvider = StateProvider<bool?>((ref) {
  return null;
});

final avatarProvider = FutureProvider<String>((ref) async {
  final wallet = await ref.watch(solanaServiceProvider).walletAddress();
  // todo: download svg avatar to memory and pull from memory unless not found

  return wallet.avatar;
});

final myUsernameProvider = FutureProvider<String?>((ref) async {
  final username = (await ref
      .read(securedStorageServiceProvider)
      .readFromStorage(Strings.myUsername));

  return username;
});

final currentAction = StateProvider<int>((ref) {
  return 0;
});

final pendingActions = FutureProvider<List<Widget>>((ref) async {
  List<Widget> widgets = [];

  final storage = ref.read(securedStorageServiceProvider);

  // check if kyc is done
  final myAccountData = await storage.readFromStorage(Strings.myAccount);

  if (myAccountData != null) {
    final account = AccountModel.fromJson(jsonDecode(myAccountData));
    if (!account.settings.kycStatus.toLowerCase().contains('verified')) {
      widgets.add(ActionBanners(
        title: 'KYC Verification',
        subtitle: 'Unlock more access',
        bannerKey: Strings.kycVerification,
        icon: R.ASSETS_ICONS_KYC_ICON_SVG,
        onTap: () {
          navkey.currentContext!.push(pKyc);
          HapticFeedback.lightImpact();
        },
      ));
    }
  }

  // check whether username is created
  final username = await storage.readFromStorage(Strings.myUsername);

  AppLogger.log(username);

  if (username == null) {
    widgets.add(ActionBanners(
      title: 'Create your @username',
      subtitle: 'A unique identity for your wallet',
      bannerKey: Strings.createUsername,
      icon: R.ASSETS_ICONS_USERNAME_ICON_SVG,
      onTap: () {
        navkey.currentContext!.push(pSetUsername);
        HapticFeedback.lightImpact();
      },
    ));
  }

  // check whether seed phrase is backed up
  final backup = await storage.readFromStorage(Strings.mnenomicBackupComplete);

  if (backup == null) {
    widgets.add(ActionBanners(
      title: 'Back up your 12/24 Key-phrase!',
      subtitle: 'Learn more',
      bannerKey: Strings.backupPhrase,
      icon: R.ASSETS_ICONS_SECURITY_LOCK_SVG,
      onTap: () {
        // true: means backup seed phrase
        // false: means just see seed phrase
        navkey.currentContext!.push(pMnenomicInstruction, extra: true);
        HapticFeedback.lightImpact();
      },
    ));
  }

  // check for cloud backup
  // todo: cloud backup check
  widgets.add(ActionBanners(
    title: 'Connect your wallet',
    subtitle: 'Unlock full functionality',
    icon: R.ASSETS_ICONS_WALLET_CONNECT_ICON_SVG,
    bannerKey: Strings.connectWallet,
    onTap: () {},
  ));

  return widgets;
});

@riverpod
class HomeNotifier extends _$HomeNotifier with ChangeNotifier {
  @override
  HomeNotifier build() {
    scrollController = ScrollController();

    return this;
  }

  late ScrollController scrollController;

  Future<void> checkUsername(String username) async {
    final result =
        await ref.read(checkUsernameUsecaseProvider).call(params: username);

    if (result.isError) {
      ref.read(isUsernameAvailableProvider.notifier).state = null;

      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          title: 'Username check failed',
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );
    } else {
      final data = (result as LoadedState).data;

      // error = true therefore username is not avaialable
      ref.read(isUsernameAvailableProvider.notifier).state =
          !(data['error'] == 'true');
    }
  }

  Future<bool> setUsername(String username) async {
    final result =
        await ref.read(setUsernameUsecaseProvider).call(params: username);

    if (result.isError) {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          title: 'Set Username failed',
          content: result.errorMessage,
          notificationType: NotificationType.error,
        ),
      );
    } else {
      navkey.currentContext!.notify.addNotification(
        NotificationTile(
          content: (result as LoadedState).data['message'],
          notificationType: NotificationType.success,
        ),
      );
    }

    return !result.isError;
  }

  Color txnColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return BrandColors.washedGreen;
      case 'failed':
        return BrandColors.washedRed;
      case 'pending':
        return BrandColors.washedBlue;
      default:
        return BrandColors.washedTextColor;
    }
  }

  Future<bool> hasShowcasedHome() async {
    return ref
        .watch(securedStorageServiceProvider)
        .doesExistInStorage(Strings.homeShowcase);
  }

  Future<void> hasShowcased() async {
    await ref.watch(securedStorageServiceProvider).writeToStorage(
          key: Strings.homeShowcase,
          value: DateTime.now().toIso8601String(),
        );
  }

  Future<String> displayAmount(TransactionsHistory data) async {
    final balance = await ref.read(balanceUsecaseProvider.future);
    final exchangeRate = balance.exchangeRate;
    final symbol = balance.symbol;

    final fmt = NumberFormat.currency(symbol: symbol, decimalDigits: 2);

    double amount = data.amount ?? 0.0;

    // If it's a wallet debit (USDC), convert to local
    if (data.type == 'wallet' && data.category == 'debit') {
      final localAmount = amount / exchangeRate;
      return fmt.format(localAmount);
    }

    // If it's a bank transaction (already in local currency)
    if (data.type == 'bank') {
      return fmt.format(amount);
    }

    // Deposits or credits are already in local currency
    if (data.category == 'credit' || data.type == 'deposit') {
      return fmt.format(amount);
    }

    // Fallback: return raw amount
    return fmt.format(amount);
  }

  Future<String> usdcAmount(TransactionsHistory data) async {
    final balance = await ref.read(balanceUsecaseProvider.future);
    final exchangeRate = balance.exchangeRate;

    double amount = data.amount ?? 0.0;

    // Wallet or deposit are already in USDC
    if (data.type == 'wallet') {
      return '\$${amount.toStringAsFixed(6)}';
    }

    // Other types (bank, credit) are in NGN and need conversion
    final usdc = amount * exchangeRate;
    return '\$${usdc.toStringAsFixed(6)}';
  }
}

GlobalKey balanceWidgetKey = GlobalKey();
GlobalKey walletDetailWidgetKey = GlobalKey();
GlobalKey avatarWidgetKey = GlobalKey();
GlobalKey scannerWidgetKey = GlobalKey();
GlobalKey transferWidgetKey = GlobalKey();
GlobalKey receiveWidgetKey = GlobalKey();
GlobalKey allTransactionsButtonWidgetKey = GlobalKey();
GlobalKey transactionSessionWidgetKey = GlobalKey();
