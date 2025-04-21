import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:guava/features/onboarding/presentation/pages/setup_pin_page.dart';
import 'package:guava/features/onboarding/presentation/pages/splash.page.dart';
import 'package:guava/features/onboarding/presentation/pages/wallet_recovery/add_connect_wallet.dart';
import 'package:guava/features/onboarding/presentation/pages/wallet_recovery/private_key.dart';
import 'package:guava/features/onboarding/presentation/pages/wallet_recovery/recovery_phase.dart';
import 'package:guava/features/receive/presentation/pages/recieve_page.dart';
import 'package:guava/features/transaction/presentation/pages/transaction_detail_page.dart';
import 'package:guava/features/transaction/presentation/pages/transaction_page.dart';
import 'package:guava/features/transfer/presentation/pages/enter_amount/enter_amount_bank.dart';
import 'package:guava/features/transfer/presentation/pages/enter_amount/enter_amount_wallet.dart';
import 'package:guava/features/transfer/presentation/pages/payment_status_page.dart';
import 'package:guava/features/transfer/presentation/pages/review_payment_page.dart';
import 'package:guava/features/transfer/presentation/pages/transfer_page.dart';

/// [p] suffix means path
const String pRoot = Strings.root;
const String pOnboarding = Strings.onboarding;
const String pDashboard = Strings.dashboard;
const String pSetupPin = Strings.setupPin;
const String pAddConnectWallet = Strings.addConnectWallet;
const String pRecoveryPhrase = Strings.importRecoveryPhrase;
const String pPrivateKey = Strings.importPrivateKey;
const String pTransfer = Strings.transfer;
const String pRecieve = Strings.recieve;
const String pEnterAmountWallet = Strings.enterAmountWallet;
const String pEnterAmountBank = Strings.enterAmountBank;
const String pReviewPayemet = Strings.reviewPayment;
const String pPaymentStatus = Strings.paymentStatus;
const String pTransaction = Strings.transaction;
const String pTransactionDetail = Strings.transactionDetail;
const String pTransactionFilter = Strings.transactionFilter;

/// GlobalKey for the Navigator state of the [AppName]
final GlobalKey<NavigatorState> navkey = GlobalKey();

// GoRouter configuration
final router = GoRouter(
  navigatorKey: navkey,
  routes: [
    GoRoute(
      name: pRoot.pathToName,
      path: pRoot,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: pOnboarding.pathToName,
      path: pOnboarding,
      builder: (context, state) => const Onboardingpage(),
    ),
    GoRoute(
      name: pDashboard.pathToName,
      path: pDashboard,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      name: pSetupPin.pathToName,
      path: pSetupPin,
      builder: (context, state) {
        return SetupPinPage();
      },
    ),
    GoRoute(
      name: pAddConnectWallet.pathToName,
      path: pAddConnectWallet,
      builder: (context, state) => const WalletRecoveryOptions(),
    ),
    GoRoute(
      name: pRecoveryPhrase.pathToName,
      path: pRecoveryPhrase,
      builder: (context, state) => const ImportRecoveryPhrase(),
    ),
    GoRoute(
      name: pPrivateKey.pathToName,
      path: pPrivateKey,
      builder: (context, state) => const ImportPrivateKey(),
    ),
    GoRoute(
      name: pTransfer.pathToName,
      path: pTransfer,
      builder: (context, state) => const TransferPage(),
    ),
    GoRoute(
      name: pRecieve.pathToName,
      path: pRecieve,
      builder: (context, state) => const RecievePage(),
    ),
    GoRoute(
      name: pEnterAmountWallet.pathToName,
      path: pEnterAmountWallet,
      builder: (context, state) => const EnterAmountWallet(),
    ),
    GoRoute(
      name: pEnterAmountBank.pathToName,
      path: pEnterAmountBank,
      builder: (context, state) => const EnterAmountBank(),
    ),
    GoRoute(
      name: pReviewPayemet.pathToName,
      path: pReviewPayemet,
      builder: (context, state) => const ReviewPaymentPage(),
    ),
    GoRoute(
      name: pPaymentStatus.pathToName,
      path: pPaymentStatus,
      builder: (context, state) => const PaymentStatusPage(),
    ),
    GoRoute(
      name: pTransaction.pathToName,
      path: pTransaction,
      builder: (context, state) => const TransactionPage(),
    ),
    GoRoute(
      name: pTransactionDetail.pathToName,
      path: pTransactionDetail,
      builder: (context, state) => const TransactionDetailPage(),
    ),
  ],
);
