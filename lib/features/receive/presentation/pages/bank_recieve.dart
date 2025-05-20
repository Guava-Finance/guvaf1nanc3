import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/resources/util/money_controller.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/receive/presentation/notifier/recieve.notifier.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class BankRecieve extends ConsumerStatefulWidget {
  const BankRecieve({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BankRecieveState();
}

class _BankRecieveState extends ConsumerState<BankRecieve> with Loader {
  late final MoneyMaskedTextController amountCtrl;
  late final MoneyMaskedTextController receiveCtrl;

  bool isValidated = false;

  @override
  void initState() {
    amountCtrl = MoneyMaskedTextController();
    receiveCtrl = MoneyMaskedTextController();

    amountCtrl.addListener(() async {
      isValidated = amountCtrl.text.isNotEmpty &&
          ((NumberFormat().tryParse(amountCtrl.text)?.toDouble() ?? 0.0) > 100);
    });

    super.initState();
  }

  Timer? timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usdcAountTransfer.notifier).state = 0.0;
      ref.watch(accountDetail.notifier).state = null;

      final country = ref.watch(userCountry);

      if (!(country?.isOffRampEnabled ?? false)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('On-ramp Unavailable'),
            content: Text(
              '''Bank transfer deposits are currently unavailable. Please use your wallet address to make a deposit.''',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.backgroundColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  ref.watch(recieveNotifierProvider).jumpTo(0);
                },
                child: Text('I Understand'),
              ),
            ],
          ),
        ).then((v) {
          timer = Timer(Durations.medium4, () {
            ref.watch(recieveNotifierProvider).jumpTo(0);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    receiveCtrl.dispose();
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rn = ref.watch(recieveNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How much are you funding?',
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: BrandColors.textColor,
            fontSize: 16.sp,
          ),
        ),
        15.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          decoration: ShapeDecoration(
            color: BrandColors.textColor.withValues(alpha: .05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                width: 1,
                color: BrandColors.textColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                readOnly: true,
                onTap: () {
                  context.push(pEnterAmountReceive).then((v) {
                    if (((v as String?) ?? '').isNotEmpty) {
                      amountCtrl.value = TextEditingValue(
                        text: v.toString(),
                      );
                    }

                    setState(() {});
                  });
                },
                controller: amountCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'You will send',
                  labelStyle: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: BrandColors.washedTextColor,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '0.00',
                  suffixIconConstraints: BoxConstraints(
                    maxWidth: 100,
                    minHeight: 10,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 10.w,
                      ),
                      decoration: ShapeDecoration(
                        color: BrandColors.textColor.withValues(alpha: .10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'NGN',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: BrandColors.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: BrandColors.washedTextColor,
                  ),
                  border: InputBorder.none,
                ),
                style: context.textTheme.bodyMedium,
              ),
              Divider(
                color: BrandColors.washedTextColor.withValues(alpha: .3),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: ref.watch(usdcAountTransfer).toStringAsFixed(2),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Wallet will recieve',
                      labelStyle: context.textTheme.bodyMedium!.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: BrandColors.washedTextColor,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: '0.00',
                      suffixIconConstraints: BoxConstraints(
                        maxWidth: 100,
                        minHeight: 10,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 10.w,
                          ),
                          decoration: ShapeDecoration(
                            color: BrandColors.textColor.withValues(alpha: .10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'USDC',
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: BrandColors.textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.washedTextColor,
                      ),
                      border: InputBorder.none,
                    ),
                    style: context.textTheme.bodyMedium,
                  );
                },
              ),
            ],
          ),
        ),
        // 16.verticalSpace,
        // Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        //   decoration: ShapeDecoration(
        //     color: BrandColors.textColor.withValues(alpha: .05),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12.r),
        //       side: BorderSide(
        //         width: 1,
        //         color: BrandColors.textColor.withValues(alpha: 0.1),
        //       ),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         'Include fee',
        //         style: context.textTheme.bodyMedium!.copyWith(
        //           fontSize: 14.sp,
        //           fontWeight: FontWeight.w500,
        //           color: BrandColors.textColor,
        //         ),
        //       ),
        //       Container(
        //         width: 35.w,
        //         height: 20.w,
        //         decoration: ShapeDecoration(
        //           color: hexColor('7A7A7A'),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(5.r),
        //           ),
        //         ),
        //         child: FlutterSwitch(
        //           borderRadius: 5.r,
        //           toggleSize: 15,
        //           padding: 3,
        //           activeColor: BrandColors.washedGreen,
        //           value: isSwitched,
        //           onToggle: (val) => setState(
        //             () {
        //               isSwitched = val;
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        40.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: ShapeDecoration(
            color: BrandColors.textColor.withValues(alpha: .05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                width: 1,
                color: BrandColors.textColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final balanceAsync = ref.watch(balanceUsecaseProvider);

                  return balanceAsync.when(
                    data: (data) {
                      final fmt = NumberFormat.currency(
                        symbol: data.symbol,
                        decimalDigits: 2,
                      );

                      return PaymentItem(
                        title: 'Our exchange rate',
                        value:
                            '''1 USDC to ${(1 * data.exchangeRate).toStringAsFixed(2)}''',
                        valueWidget: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: CustomIcon(
                                  icon: R.ASSETS_ICONS_USD_COIN_SVG,
                                  height: 15.h,
                                  width: 15.w,
                                ),
                              ),
                              TextSpan(text: ' 1'),
                              TextSpan(text: ' to '),
                              TextSpan(text: fmt.format(data.exchangeRate)),
                            ],
                          ),
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: BrandColors.washedTextColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      );
                    },
                    error: (_, __) {
                      return 0.verticalSpace;
                    },
                    loading: () {
                      return 0.verticalSpace;
                    },
                  );
                },
              ),
              15.verticalSpace,
              PaymentItem(
                title: 'Payment method',
                value: 'Bank transfer',
              ),
            ],
          ),
        ),
        Spacer(),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (_, data, __) {
            return CustomButton(
              onTap: () async {
                withLoading(() async {
                  final result = await rn.initDeposit();

                  if (result) {
                    navkey.currentContext!.mixpanel.track(
                      MixpanelEvents.depositInitiated,
                    );
                    navkey.currentContext!.mixpanel.timetrack(
                      MixpanelEvents.depositCompleted,
                    );

                    navkey.currentContext!.push(pAccountPayable);
                  }
                });
              },
              title: 'Continue',
              disable: !isValidated,
              isLoading: data,
            );
          },
        ),
        20.verticalSpace,
      ],
    );
  }
}
