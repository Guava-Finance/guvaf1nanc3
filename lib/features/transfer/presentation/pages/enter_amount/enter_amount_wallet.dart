import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/resources/util/debouncer.dart';
import 'package:guava/core/resources/util/money_controller.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/onboarding/presentation/widgets/number_pad.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/balance_text.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class EnterAmountWallet extends ConsumerStatefulWidget {
  const EnterAmountWallet({
    this.onComplete,
    this.subtitle,
    this.title,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Function(String)? onComplete;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnterAmountWalletState();
}

class _EnterAmountWalletState extends ConsumerState<EnterAmountWallet>
    with Loader {
  final debounce = Debouncer(duration: Durations.extralong4);

  late final MoneyMaskedTextController amountCtrl;
  late final TextEditingController controller;

  bool isValidated = false;

  @override
  void initState() {
    amountCtrl = MoneyMaskedTextController();
    controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(firebaseAnalyticsProvider)
          .triggerScreenLogged(runtimeType.toString());

      controller.value = TextEditingValue(
        text: ref.read(receipentAddressProvider.notifier).state ?? '',
      );

      amountCtrl.addListener(() async {
        final balanceAsync = await ref.read(balanceUsecaseProvider.future);
        final amount = NumberFormat().tryParse(amountCtrl.text)?.toDouble();

        usdcAmount = (amount ?? 0.0) / balanceAsync.exchangeRate;

        isValidated =
            (amount ?? 0.0) > 0 && (amount ?? 0.0) <= balanceAsync.localBalance;

        ref.watch(usdcAountTransfer.notifier).state = usdcAmount;
        ref.watch(localAountTransfer.notifier).state = amount ?? 0.0;

        setState(() {});
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  bool readOnly = true;

  double usdcAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '₦', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter amount',
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: BrandColors.textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  24.verticalSpace,
                  CustomTextfield(
                    readOnly: readOnly,
                    controller: controller,
                    onChanged: (p0) {
                      ref.read(receipentAddressProvider.notifier).state = null;

                      if ((p0 ?? '').length > 2) {
                        debounce.run(() {
                          withLoading(() async {
                            await ref
                                .read(transferNotifierProvider)
                                .resolveAddress(p0 ?? '');
                          });
                        });
                      }
                    },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   readOnly = !readOnly;
                        // });
                        context.pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 12.w,
                        ),
                        decoration: ShapeDecoration(
                          color: BrandColors.containerColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          readOnly ? 'Edit' : 'Okay',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: BrandColors.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  BalanceText(),
                  40.verticalSpace,
                  TextFormField(
                    readOnly: true,
                    controller: amountCtrl,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: currency.format(0.00),
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.washedTextColor,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                    ),
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.light,
                    ),
                    textAlign: TextAlign.center,
                  ).padHorizontal,
                  // 10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          decoration: ShapeDecoration(
                            color: BrandColors.containerColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: usdcAmount.formatAmount(),
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      color: BrandColors.textColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${(usdcAmount).formatDecimal} USDC',
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      color: BrandColors.washedTextColor,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ]),
                              ),
                              // 7.horizontalSpace,
                              // SvgPicture.asset(
                              //   R.ASSETS_ICONS_EXCHANGE_SVG,
                              //   width: 10.w,
                              //   height: 10.h,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).padHorizontal,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomNumberPad(
            controller: amountCtrl,
            isAmountPad: true,
          ),
          40.verticalSpace,
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, snapshot, child) {
              return Consumer(
                builder: (context, ref, child) {
                  return CustomButton(
                    onTap: () {
                      context.push(pReviewPayemet);
                    },
                    title: 'Next',
                    disable: !isValidated,
                    isLoading: snapshot,
                  ).padHorizontal;
                },
              );
            },
          ),
          40.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
