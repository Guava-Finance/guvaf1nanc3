import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/dashboard/presentation/notifier/dashboard_notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/utility_widget.dart';

class BottomNavigator extends ConsumerWidget {
  const BottomNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavProvider);

    return BottomNavigationBar(
      backgroundColor: BrandColors.scaffoldColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        color: BrandColors.selectedNavBarLabel,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        color: BrandColors.textColor,
      ),
      selectedItemColor: Colors.white,
      unselectedItemColor: hexColor('#B0B7B1'),
      currentIndex: selectedIndex,
      onTap: (index) => ref.read(bottomNavProvider.notifier).setIndex(index),
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Column(
            children: [
              CustomIcon(
                icon: R.ASSETS_ICONS_HOME_INACTIVE_ICON_SVG,
              ),
              SizedBox(height: 5.h),
            ],
          ),
          activeIcon: Column(
            children: [
              CustomIcon(
                icon: R.ASSETS_ICONS_HOME_ACTIVE_ICON_SVG,
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
        BottomNavigationBarItem(
          label: 'Account',
          icon: Column(
            children: [
              CustomIcon(
                icon: R.ASSETS_ICONS_ACCOUNT_INACTIVE_SVG,
              ),
              SizedBox(height: 5.h),
            ],
          ),
          activeIcon: Column(
            children: [
              CustomIcon(
                icon: R.ASSETS_ICONS_ACCOUNT_ACTIVE_SVG,
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ],
    );
  }
}
