import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/entities/account_detail.dart';
import 'package:guava/features/transfer/domain/entities/bank_beneficiary.dart';
import 'package:guava/features/transfer/domain/entities/recent_bank_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/bank_beneficiary.dart';
import 'package:guava/features/transfer/domain/usecases/recent_bank_transfer.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/recent_bank_transfers.dart';
import 'package:guava/widgets/app_icon.dart';

class BankTabBarView extends ConsumerWidget {
  const BankTabBarView({
    required this.tabController,
    super.key,
  });

  final TabController? tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: tabController,
                  splashBorderRadius: BorderRadius.circular(32.r),
                  padding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.white,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  indicatorWeight: 2,
                  isScrollable: true,
                  unselectedLabelColor: BrandColors.washedTextColor,
                  dividerHeight: 0,
                  labelColor: BrandColors.light,
                  labelStyle: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: BrandColors.light,
                  ),
                  tabs: const [
                    Tab(text: 'Recents'),
                    Tab(text: 'Beneficiary'),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              splashColor: BrandColors.primary,
              icon: CustomIcon(
                icon: R.ASSETS_ICONS_SEARCH_SVG,
                color: BrandColors.primary,
                width: 13.w,
                height: 13.h,
              ),
            ),
            8.horizontalSpace,
          ],
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final recentTransfer = ref.watch(recentBankTransfersProvider);

                  return recentTransfer.when(
                    data: (data) {
                      return RecentBankTransfers<RecentBankTransfer>(
                        list: data,
                        onTap: (p0) {},
                        onRefresh: () async {
                          ref.invalidate(recentBankTransfersProvider);
                        },
                      );
                    },
                    error: (_, __) {
                      return 0.verticalSpace;
                    },
                    loading: () {
                      return RecentBankTransfers(
                        isLoading: true,
                        onRefresh: () async {
                          ref.invalidate(recentBankTransfersProvider);
                        },
                      );
                    },
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final bankBeneficiary = ref.watch(bankBeneficiaryProvider);

                  return bankBeneficiary.when(
                    data: (data) {
                      return RecentBankTransfers<BankBeneficiary>(
                        list: data,
                        onTap: (p0) {},
                        onRefresh: () async {
                          ref.invalidate(bankBeneficiaryProvider);
                        },
                      );
                    },
                    error: (_, __) {
                      return 0.verticalSpace;
                    },
                    loading: () {
                      return RecentBankTransfers(
                        isLoading: true,
                        onRefresh: () async {
                          ref.invalidate(bankBeneficiaryProvider);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
