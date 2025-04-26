import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/pages/wallet_transfer.dart';
import 'package:guava/features/transfer/presentation/pages/bank_transfer.dart';
import 'package:guava/features/transfer/presentation/widgets/transfer_type_selector.dart';

class TransferPage extends ConsumerWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.watch(transferNotifierProvider.notifier);
        final tabState = ref.watch(activeTabState.notifier);

        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: TransferTypeSelector(
                  selected: tabState.state,
                  onChanged: (value) {
                    setState(() {
                      tabState.state = (value);
                      notifier.jumpTo(value);
                    });
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      R.ASSETS_ICONS_SCAN_ICON_SVG,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  6.horizontalSpace,
                ],
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          12.verticalSpace,
                          Expanded(
                            child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: notifier.pageController,
                              children: const [
                                WalletTransfer(),
                                BankTransfer(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
