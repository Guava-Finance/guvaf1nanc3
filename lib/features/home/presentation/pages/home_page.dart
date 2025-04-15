import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/features/home/presentation/pages/sub/actions.dart';
import 'package:guava/features/home/presentation/pages/sub/category.dart';
import 'package:guava/features/home/presentation/pages/sub/home.wallet.dart';
import 'package:guava/features/home/presentation/pages/sub/quick_menu.dart';
import 'package:guava/features/home/presentation/pages/sub/txn_session.dart';
import 'package:guava/features/home/presentation/pages/sub/wallet_balance.dart';
import 'package:guava/features/home/presentation/widgets/appbar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.verticalSpace,
            HomeAppbar(),
            10.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
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
                    ActionTasks(),
                    24.verticalSpace,
                    CategorySession(),
                    24.verticalSpace,
                    TransactionHistorySession(),
                    50.verticalSpace,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
