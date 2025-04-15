import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/pages/account_page.dart';
import 'package:guava/features/dashboard/presentation/notifier/dashboard_notifier.dart';
import 'package:guava/features/dashboard/presentation/widgets/bottom/nav.dart';
import 'package:guava/features/home/presentation/pages/home_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavProvider);

    final screens = [
      const HomePage(),
      const AccountPage(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: screens[selectedIndex],
        bottomNavigationBar: Container(
          height: Platform.isIOS ? 100.h : 70.h,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: BrandColors.textColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: BottomNavigator(),
        ),
      ),
    );
  }
}
