import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/util/navigator_observer.dart';
import 'package:guava/core/routes/cache.dart';
import 'package:guava/core/routes/features/account.dart';
import 'package:guava/core/routes/features/dashboard.dart';
import 'package:guava/core/routes/features/kyc.dart';
import 'package:guava/core/routes/features/onboarding.dart';
import 'package:guava/core/routes/features/payment.dart';
import 'package:guava/core/routes/features/solana_pay.dart';
import 'package:guava/core/routes/features/transaction.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/onboarding/presentation/pages/splash.page.dart';

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
const String pEnterAmountReceive = Strings.enterAmountReceive;
const String pReviewPayemet = Strings.reviewPayment;
const String pPaymentStatus = Strings.paymentStatus;
const String pTransaction = Strings.transaction;
const String pTransactionDetail = Strings.transactionDetail;
const String pTransactionFilter = Strings.transactionFilter;
const String pSetUsername = Strings.setUsername;
const String pKyc = Strings.kycPage;
const String pKycDone = Strings.kycDonePage;
const String pScanner = Strings.scannerPage;
const String pAccountPayable = Strings.accountPayable;
const String pMnenomicInstruction = Strings.mnenomicInstruction;
const String pAccessPin = Strings.accessPin;
const String pMnenomicShow = Strings.mnenomicShow;
const String pMnenomicValidation = Strings.mnenomicValidation;
const String pMnenomicBackupComplete = Strings.mnenomicBackupComplete;
const String pProfile = Strings.profilePage;
const String pSettings = Strings.settingsPage;
const String pPrivacyPolicy = Strings.privacyPolicyPage;
const String pSupport = Strings.supportPage;

// Solana Pay
const String pSolanaPayReview = Strings.solanaPayReview;
const String pSolanaPayStatus = Strings.solanaPayStatus;

/// GlobalKey for the Navigator state of the [AppName]
final GlobalKey<NavigatorState> navkey = GlobalKey();

// Main router configuration with route groups
final router = GoRouter(
  navigatorKey: navkey,
  observers: [RouteObserverImpl()],
  refreshListenable: CachedRouteNotifier(), // Listens for cache invalidation
  routes: [
    // Root route
    GoRoute(
      name: Strings.root.pathToName,
      path: Strings.root,
      builder: (context, state) => const SplashPage(),
    ),

    // Feature-based route groups
    ...onboardingRoutes,
    ...dashboardRoutes,
    ...accountRoutes,
    ...paymentRoutes,
    ...transactionRoutes,
    ...kycRoutes,
    ...solanaPayRoutes,
  ],
  redirect: (context, state) {
    // Check if this route exists in cache
    final cachedRoute = CachedRouteManager.getCachedRoute(
      state.fullPath ?? pRoot,
    );
    if (cachedRoute != null) {
      // Return null to continue to the requested route with cached data
      return null;
    }

    // Normal routing, no redirection needed
    return null;
  },
);
