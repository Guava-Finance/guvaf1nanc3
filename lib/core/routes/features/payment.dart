import 'package:go_router/go_router.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/features/receive/presentation/pages/account_payable.dart';
import 'package:guava/features/receive/presentation/pages/amount/enter_amount.dart';
import 'package:guava/features/receive/presentation/pages/recieve_page.dart';
import 'package:guava/features/transfer/presentation/pages/authorize.dart';
import 'package:guava/features/transfer/presentation/pages/enter_amount/enter_amount_bank.dart';
import 'package:guava/features/transfer/presentation/pages/enter_amount/enter_amount_wallet.dart';
import 'package:guava/features/transfer/presentation/pages/payment_status_page.dart';
import 'package:guava/features/transfer/presentation/pages/review_payment_page.dart';
import 'package:guava/features/transfer/presentation/pages/scanner.dart';
import 'package:guava/features/transfer/presentation/pages/transfer_page.dart';

/// Payment related routes
final List<RouteBase> paymentRoutes = [
  // Transfer routes
  GoRoute(
    name: Strings.transfer.pathToName,
    path: Strings.transfer,
    builder: (context, state) {
      final initialAddress = state.extra as String?;
      return TransferPage(
        initialAddress: initialAddress,
      );
    },
  ),
  GoRoute(
    name: Strings.enterAmountWallet.pathToName,
    path: Strings.enterAmountWallet,
    builder: (context, state) => const EnterAmountWallet(),
  ),
  GoRoute(
    name: Strings.enterAmountBank.pathToName,
    path: Strings.enterAmountBank,
    builder: (context, state) => const EnterAmountBank(),
  ),
  GoRoute(
    name: Strings.reviewPayment.pathToName,
    path: Strings.reviewPayment,
    builder: (context, state) {
      return ReviewPaymentPage(
        fromPayAnyone: (state.extra as bool?) ?? false,
      );
    },
  ),
  GoRoute(
    name: Strings.paymentStatus.pathToName,
    path: Strings.paymentStatus,
    builder: (context, state) => const PaymentStatusPage(),
  ),
  GoRoute(
    name: Strings.scannerPage.pathToName,
    path: Strings.scannerPage,
    builder: (context, state) => const WalletScannerPage(),
  ),

  // Receive routes
  GoRoute(
    name: Strings.recieve.pathToName,
    path: Strings.recieve,
    builder: (context, state) => const RecievePage(),
  ),
  GoRoute(
    name: Strings.enterAmountReceive.pathToName,
    path: Strings.enterAmountReceive,
    builder: (context, state) => const EnterAmountReceive(),
  ),
  GoRoute(
    name: Strings.accountPayable.pathToName,
    path: Strings.accountPayable,
    builder: (context, state) => const AccountPayablePage(),
  ),
  GoRoute(
    name: Strings.authorizeTxn.pathToName,
    path: Strings.authorizeTxn,
    builder: (context, state) => const AuthorizeTransaction(),
  ),
];
