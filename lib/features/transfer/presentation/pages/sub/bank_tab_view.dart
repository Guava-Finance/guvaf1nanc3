import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/recent_bank_transfers.dart';

class BankTabBarView extends StatelessWidget {
  const BankTabBarView({
    required this.tabController,
    required this.controller,
    super.key,
  });

  final TabController? tabController;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 50.w),
          alignment: Alignment.center,
          child: TabBar(
            controller: tabController,
            splashBorderRadius: BorderRadius.circular(32.r),
            padding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 25.w),
            indicatorWeight: 2,
            unselectedLabelColor: BrandColors.washedTextColor,
            dividerHeight: 0,
            labelColor: BrandColors.light,
            labelStyle: context.textTheme.bodyMedium!.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: BrandColors.light,
            ),
            tabs: const [
              Tab(
                text: 'Recents',
              ),
              Tab(
                text: 'Beneficiary',
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              RecentBankTransfers(controller: controller),
              RecentBankTransfers(controller: controller),
            ],
          ),
        )
      ],
    );
  }
}
