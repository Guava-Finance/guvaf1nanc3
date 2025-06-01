import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/resources/services/wallet_connection.dart';
import 'package:guava/core/resources/util/debouncer.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/domain/usecases/history.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/home/presentation/pages/sub/actions.dart';
import 'package:guava/features/home/presentation/pages/sub/category.dart';
import 'package:guava/features/home/presentation/pages/sub/home.wallet.dart';
import 'package:guava/features/home/presentation/pages/sub/pay_anyone.dart';
import 'package:guava/features/home/presentation/pages/sub/quick_menu.dart';
import 'package:guava/features/home/presentation/pages/sub/txn_session.dart';
import 'package:guava/features/home/presentation/pages/sub/wallet_balance.dart';
import 'package:guava/features/home/presentation/widgets/appbar.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final debouncer = Debouncer(duration: Duration(seconds: 7));

  final scaffldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectionStatus = ref.watch(walletConnectionProvider);
      final error = ref.watch(walletConnectionErrorProvider);

      Future.delayed(Duration(seconds: 5), () {
        ref.read(walletConnectionProvider.notifier).connect();
      });
      //   ref
      //       .read(firebaseAnalyticsProvider)
      //       .triggerScreenLogged(runtimeType.toString());

      //   debouncer.run(() async {
      //     if (mounted) {
      //       if (!(await ref.watch(homeNotifierProvider).hasShowcasedHome())) {
      //         ShowCaseWidget.of(scaffldKey.currentContext!).startShowCase([
      //           balanceWidgetKey,
      //           walletDetailWidgetKey,
      //           avatarWidgetKey,
      //           scannerWidgetKey,
      //           payAnyoneWidgetKey,
      //           transferWidgetKey,
      //           receiveWidgetKey,
      //         ]);
      //       }
      //     }
      //   });
    });
  }

  int set = 0;

  @override
  Widget build(BuildContext context) {
    final hn = ref.watch(homeNotifierProvider);

    return ShowCaseWidget(
      onStart: (p0, p1) {},
      onComplete: (p0, p1) {},
      enableShowcase: true,
      onFinish: () async {
        set++;

        if (set == 1) {
          await hn.scrollController.animateTo(
            hn.scrollController.position.maxScrollExtent,
            duration: Durations.extralong2,
            curve: Curves.linear,
          );

          ShowCaseWidget.of(scaffldKey.currentContext!).startShowCase([
            allTransactionsButtonWidgetKey,
            transactionSessionWidgetKey,
            otherAssetsWidgetKey,
          ]);
        }

        if (set == 2) {
          await hn.scrollController.animateTo(
            hn.scrollController.position.minScrollExtent,
            duration: Durations.extralong2,
            curve: Curves.linear,
          );

          await ref.watch(homeNotifierProvider).hasShowcased();
        }
      },
      builder: (context) => Scaffold(
        key: scaffldKey,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(balanceUsecaseProvider);
              ref.invalidate(walletAddressProvider);
              ref.invalidate(myTransactionHistory);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.verticalSpace,
                HomeAppbar(),
                10.verticalSpace,
                Expanded(
                  child: SingleChildScrollView(
                    controller:
                        ref.watch(homeNotifierProvider).scrollController,
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        14.verticalSpace,
                        WalletDetails(),
                        24.verticalSpace,
                        WalletBalance(),
                        24.verticalSpace,
                        QuickMenu(),
                        16.verticalSpace,
                        PayAnyone(),
                        16.verticalSpace,
                        ActionTasks(),
                        24.verticalSpace,
                        CategorySession(),
                        24.verticalSpace,
                        TransactionHistorySession(),
                        50.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
