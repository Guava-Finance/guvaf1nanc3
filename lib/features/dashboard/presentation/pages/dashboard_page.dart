import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/pages/account_page.dart';
import 'package:guava/features/dashboard/presentation/notifier/dashboard_notifier.dart';
import 'package:guava/features/home/presentation/pages/home_page.dart';
import 'package:guava/widgets/utility_widget.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dashboardProvider);

    final screens = [
      const HomePage(),
      const AccountPage(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        height: Platform.isIOS ? 100.h : 70.h,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: hexColor('#FCFCFC').withValues(alpha: 0.3)))),
        child: BottomNavigationBar(
          backgroundColor: BrandColors.scaffoldColor,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              TextStyle(fontSize: 12.sp, color: hexColor('#B0B7B1')),
          unselectedLabelStyle:
              TextStyle(fontSize: 12.sp, color: hexColor('#FCFCFC')),
          selectedItemColor: Colors.white,
          unselectedItemColor: hexColor('#B0B7B1'),
          currentIndex: selectedIndex,
          onTap: (index) =>
              ref.read(dashboardProvider.notifier).setIndex(index),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Column(
                children: [
                  Image.asset(R.ASSETS_IMAGES_HOME_PNG, height: 20.h),
                  SizedBox(height: 5.h),
                ],
              ),
              activeIcon: Column(
                children: [
                  Image.asset(R.ASSETS_IMAGES_HOME_ACTIVE_PNG, height: 20.h),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: 'Account',
              icon: Column(
                children: [
                  Image.asset(R.ASSETS_IMAGES_ACCOUNT_PNG, height: 20.h),
                  SizedBox(height: 5.h),
                ],
              ),
              activeIcon: Column(
                children: [
                  Image.asset(R.ASSETS_IMAGES_ACCOUNT_ACTIVE_PNG, height: 20.h),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
