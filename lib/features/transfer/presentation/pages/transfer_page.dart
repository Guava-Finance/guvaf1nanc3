import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/util/debouncer.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/pages/wallet_transfer.dart';
import 'package:guava/features/transfer/presentation/pages/bank_transfer.dart';
import 'package:guava/features/transfer/presentation/widgets/transfer_type_selector.dart';
import 'package:showcaseview/showcaseview.dart';

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({
    this.initialAddress,
    super.key,
  });

  // Parameter to receive address from route navigation
  final String? initialAddress;

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final scaffoldKey = GlobalKey();
  final debouncer = Debouncer(duration: Duration(seconds: 2));

  String? walletAddress;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(firebaseAnalyticsProvider)
          .triggerScreenLogged(runtimeType.toString());

      // Process initial address if provided through route navigation
      if (widget.initialAddress != null && widget.initialAddress!.isNotEmpty) {
        setState(() {
          walletAddress = widget.initialAddress;
        });

        // Update the provider state with the initial address
        if (ref.exists(receipentAddressProvider)) {
          ref.read(receipentAddressProvider.notifier).state =
              widget.initialAddress;
        }
      } else {
        // Reset the address provider if no initial address
        ref.read(receipentAddressProvider.notifier).state = null;
      }

      ref.read(accountDetail.notifier).state = null;
      ref.read(usdcAountTransfer.notifier).state = 0.0;
      ref.read(localAountTransfer.notifier).state = 0.0;
      ref.read(payingAnyone.notifier).state = false;

      setState(() {});

      debouncer.run(() async {
        if (!(await ref
            .watch(transferNotifierProvider)
            .hasShowcasedTransfer())) {
          ShowCaseWidget.of(scaffoldKey.currentContext!).startShowCase([
            transferToggleWidgetKey,
            recipientWidgetKey,
          ]);
        }
      });
    });
  }

  @override
  void dispose() {
    debouncer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.watch(transferNotifierProvider.notifier);
        final tabState = ref.watch(activeTabState);

        return ShowCaseWidget(
          onFinish: () async {
            await notifier.hasShowcased();
          },
          builder: (context) => Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Showcase(
                key: transferToggleWidgetKey,
                description:
                    '''Toggle between send money out via wallet transfer or via banks (i.e. off ramping)''',
                targetBorderRadius: BorderRadius.circular(20.r),
                child: TransferTypeSelector(
                  selected: tabState,
                  onChanged: (value) {
                    notifier.jumpTo(value);
                  },
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.push(pScanner).then((v) {
                      if (v != null) {
                        final scannedValue = v.toString();

                        // Store the wallet address
                        setState(() {
                          walletAddress = scannedValue;
                        });

                        // Switch to wallet transfer tab if not already there
                        if (tabState != 0) notifier.jumpTo(0);

                        // Update the provider state
                        if (ref.exists(receipentAddressProvider)) {
                          ref.read(receipentAddressProvider.notifier).state =
                              scannedValue;
                        }
                      }
                    });
                  },
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
                            children: [
                              WalletTransfer(walletAddress: walletAddress),
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
          ),
        );
      },
    );
  }
}
