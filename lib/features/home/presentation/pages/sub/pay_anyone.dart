import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/transfer/domain/usecases/banks_usecase.dart';
import 'package:guava/features/transfer/domain/usecases/countries_usecase.dart';
import 'package:guava/features/transfer/domain/usecases/purpose.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';
import 'package:guava/widgets/selctor.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';

class PayAnyone extends ConsumerStatefulWidget {
  const PayAnyone({
    super.key,
  });

  @override
  ConsumerState<PayAnyone> createState() => _PayAnyoneState();
}

class _PayAnyoneState extends ConsumerState<PayAnyone> with Loader {
  late final TextEditingController countryCtrl,
      bankCtrl,
      accountNumberCtrl,
      amountCtrl,
      purposeCtrl;

  @override
  void initState() {
    countryCtrl = TextEditingController();
    bankCtrl = TextEditingController();
    accountNumberCtrl = TextEditingController();
    amountCtrl = TextEditingController();
    purposeCtrl = TextEditingController();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(payingAnyone.notifier).state = false;
    });
  }

  bool get isValidated {
    final controllers = [
      countryCtrl,
      bankCtrl,
      accountNumberCtrl,
      amountCtrl,
      purposeCtrl,
    ];

    return (ref.watch(accountDetail) != null &&
        controllers.every((e) => e.text.isNotEmpty));
  }

  @override
  void dispose() {
    countryCtrl.dispose();
    bankCtrl.dispose();
    accountNumberCtrl.dispose();
    amountCtrl.dispose();
    purposeCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tn = ref.watch(transferNotifierProvider);

    return Consumer(
      builder: (context, ref, child) {
        final payAnyone = ref.watch(payingAnyone);
        final shaked = ref.watch(shakedPayAnyone);

        return ShakeX(
          delay: Durations.extralong4,
          duration: Durations.long4,
          animate: !shaked,
          from: 10,
          onFinish: (direction) {
            ref.watch(shakedPayAnyone.notifier).state = true;
          },
          child: Showcase(
            key: payAnyoneWidgetKey,
            description: 'Instantly make a transfer to anyone',
            targetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AnimatedContainer(
              duration: Durations.medium2,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 20.w,
              ),
              decoration: ShapeDecoration(
                color: BrandColors.containerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadows: [
                  if (payAnyone) ...{
                    BoxShadow(
                      color: BrandColors.primary,
                      blurRadius: 10,
                      spreadRadius: .3,
                    ),
                  },
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        ref.watch(payingAnyone.notifier).state = !payAnyone;

                        countryCtrl.clear();
                        bankCtrl.clear();
                        accountNumberCtrl.clear();
                        ref.read(accountDetail.notifier).state = null;
                        amountCtrl.clear();
                        purposeCtrl.clear();
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      maxRadius: 24.r,
                      backgroundColor: BrandColors.washedBlue,
                      child: CustomIcon(
                        icon: R.ASSETS_ICONS_BANK_SVG,
                        width: 16.w,
                        height: 16.h,
                        color: BrandColors.textColor,
                      ),
                    ),
                    title: Text(
                      payAnyone
                          ? 'Payment in progress'
                          : 'Start a bank transfer',
                      style: context.textTheme.bodyMedium,
                    ),
                    subtitle: payAnyone
                        ? null
                        : Text(
                            'Instant payout',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              color: BrandColors.washedTextColor,
                            ),
                          ),
                    trailing: AnimatedContainer(
                      duration: Durations.medium2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: BrandColors.textColor.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        payAnyone ? 'Cancel' : 'Pay anyone',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: payAnyone,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        16.verticalSpace,
                        Consumer(
                          builder: (context, ref, child) {
                            final countries =
                                ref.watch(listOfSupportedCountriesProvider);

                            return countries.when(
                              data: (data) {
                                return CustomTextfield(
                                  height: 0.h,
                                  readOnly: true,
                                  onTap: () {
                                    CustomListPicker(
                                      title: 'Select Recipient Country',
                                      options: (data ?? [])
                                          .map((e) => e.name)
                                          .toList(),
                                      onTap: (p0) {
                                        countryCtrl.value =
                                            TextEditingValue(text: p0);

                                        ref
                                            .read(selectedCountry.notifier)
                                            .state = data!.firstWhere(
                                          (e) =>
                                              e.name.toLowerCase() ==
                                              p0.toLowerCase(),
                                        );

                                        ref.invalidate(listOfBanksProvider);

                                        setState(() {});
                                      },
                                    ).bottomSheet;
                                  },
                                  hintText: 'Select Country',
                                  controller: countryCtrl,
                                  suffixIcon: CustomIcon(
                                    icon: R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                                  ),
                                );
                              },
                              error: (_, __) {
                                return CustomTextfield(
                                  height: 0.h,
                                  readOnly: true,
                                  hintText: 'Select Country',
                                  controller: countryCtrl,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      ref.invalidate(
                                          listOfSupportedCountriesProvider);
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: BrandColors.textColor,
                                    ),
                                  ),
                                );
                              },
                              loading: () {
                                return CustomTextfield(
                                  height: 0.h,
                                  readOnly: true,
                                  hintText: 'Select Country',
                                  controller: countryCtrl,
                                  suffixIcon: CupertinoActivityIndicator(
                                    radius: 12.r,
                                    color: BrandColors.primary,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Visibility(
                          visible: countryCtrl.value.text.isNotEmpty,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              10.verticalSpace,
                              Consumer(
                                builder: (context, ref, child) {
                                  final banks = ref.watch(listOfBanksProvider);

                                  return banks.when(
                                    data: (data) {
                                      return CustomTextfield(
                                        height: 0.h,
                                        readOnly: true,
                                        onTap: () {
                                          accountNumberCtrl.clear();

                                          CustomListPicker(
                                            title: 'Select Recipient Bank',
                                            options: (data ?? [])
                                                .map((e) => e.name)
                                                .toList(),
                                            onTap: (p0) {
                                              bankCtrl.value =
                                                  TextEditingValue(text: p0);

                                              final bank = data!.firstWhere(
                                                  (e) =>
                                                      e.name.toLowerCase() ==
                                                      p0.toLowerCase());

                                              AppLogger.log(bank.code);
                                              AppLogger.log(bank.name);

                                              tn.accountResolutionData['bank'] =
                                                  bank.code;

                                              setState(() {});
                                            },
                                          ).bottomSheet;
                                        },
                                        hintText: 'Select Bank',
                                        controller: bankCtrl,
                                        suffixIcon: SvgPicture.asset(
                                          R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                                        ),
                                      );
                                    },
                                    error: (_, __) {
                                      return CustomTextfield(
                                        height: 0.h,
                                        readOnly: true,
                                        hintText: 'Select Bank',
                                        controller: bankCtrl,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            ref.invalidate(listOfBanksProvider);
                                          },
                                          icon: Icon(
                                            Icons.refresh,
                                            color: BrandColors.textColor,
                                          ),
                                        ),
                                      );
                                    },
                                    loading: () {
                                      return CustomTextfield(
                                        height: 0.h,
                                        readOnly: true,
                                        hintText: 'Select Bank',
                                        controller: bankCtrl,
                                        suffixIcon: CupertinoActivityIndicator(
                                          radius: 12.r,
                                          color: BrandColors.primary,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              10.verticalSpace,
                            ],
                          ),
                        ),
                        Visibility(
                          visible: bankCtrl.value.text.isNotEmpty,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextfield(
                                height: 0.h,
                                hintText: 'Enter 10 digit account number',
                                controller: accountNumberCtrl,
                                inputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (p0) async {
                                  ref.watch(accountDetail.notifier).state =
                                      null;

                                  final country = ref.watch(userCountry);

                                  if ((p0 ?? '').length ==
                                      (country?.bankAccountLenght ?? 10)) {
                                    context.focusScope.unfocus();

                                    tn.accountResolutionData['account'] = p0;

                                    await withLoading(() async {
                                      await tn.resolveAccount();
                                    });

                                    setState(() {});
                                  }
                                },
                              ),
                              10.verticalSpace,
                            ],
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final detail = ref.watch(accountDetail);

                            return detail == null
                                ? 0.verticalSpace
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 12.w,
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: BrandColors.textColor
                                            .withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomIcon(
                                          icon: R.ASSETS_ICONS_CHECKMARK_SVG,
                                          width: 14.w,
                                          height: 14.h,
                                        ),
                                        8.horizontalSpace,
                                        Expanded(
                                          child: Text(
                                            detail.accountName,
                                            style: context.textTheme.bodyMedium!
                                                .copyWith(
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                        Visibility(
                          visible: accountNumberCtrl.value.text.isNotEmpty,
                          child: CustomTextfield(
                            height: 0.h,
                            readOnly: true,
                            hintText: 'Enter amount',
                            controller: amountCtrl,
                            onTap: () async {
                              final balance =
                                  await ref.read(balanceUsecaseProvider.future);

                              navkey.currentContext!
                                  .push(pEnterAmountBank)
                                  .then((v) {
                                if (((v as String?) ?? '').isNotEmpty) {
                                  final amount = NumberFormat()
                                          .tryParse(v.toString())
                                          ?.toDouble() ??
                                      0.0;

                                  ref.read(localAountTransfer.notifier).state =
                                      amount;
                                  ref.read(usdcAountTransfer.notifier).state =
                                      (amount / balance.exchangeRate);

                                  amountCtrl.value = TextEditingValue(
                                    text: NumberFormat.currency(
                                            symbol: balance.symbol)
                                        .format(
                                      amount,
                                    ),
                                  );

                                  setState(() {});
                                }
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: amountCtrl.value.text.isNotEmpty,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              10.verticalSpace,
                              Consumer(
                                builder: (context, ref, child) {
                                  final purpose =
                                      ref.watch(lisOfTransferPurpose);

                                  return purpose.when(
                                    data: (d) {
                                      return CustomTextfield(
                                        height: 0.h,
                                        readOnly: true,
                                        onTap: () {
                                          CustomListPicker(
                                            title: 'What is the purpose',
                                            options: (d ?? [])
                                                .map((e) => e.title)
                                                .toList(),
                                            onTap: (p0) {
                                              purposeCtrl.value =
                                                  TextEditingValue(text: p0);

                                              final data =
                                                  (d ?? []).firstWhere((e) {
                                                return e.title.toLowerCase() ==
                                                    p0.toLowerCase();
                                              });

                                              ref
                                                  .read(
                                                      selectedPurpose.notifier)
                                                  .state = data;

                                              setState(() {});
                                            },
                                          ).bottomSheet;
                                        },
                                        hintText: 'Purpose of transaction',
                                        controller: purposeCtrl,
                                        suffixIcon: SvgPicture.asset(
                                          R.ASSETS_ICONS_ARROW_FORWARD_SVG,
                                        ),
                                      );
                                    },
                                    error: (_, __) {
                                      return CustomTextfield(
                                        height: 0.h,
                                        readOnly: true,
                                        hintText: 'Purpose of transaction',
                                        controller: purposeCtrl,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            ref.invalidate(
                                                lisOfTransferPurpose);
                                          },
                                          icon: Icon(Icons.refresh),
                                        ),
                                      );
                                    },
                                    loading: () {
                                      return CustomTextfield(
                                        height: 0.h,
                                        readOnly: true,
                                        hintText: 'Purpose of transaction',
                                        controller: purposeCtrl,
                                        suffixIcon: CupertinoActivityIndicator(
                                          radius: 12.r,
                                          color: BrandColors.primary,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              20.verticalSpace,
                            ],
                          ),
                        ),
                        Visibility(
                          visible: purposeCtrl.text.isNotEmpty,
                          child: ValueListenableBuilder(
                            valueListenable: isLoading,
                            builder: (_, data, child) {
                              return CustomButton(
                                onTap: () {
                                  context.push(pReviewPayemet, extra: true);
                                },
                                title: 'Continue',
                                isLoading: data,
                                disable: !isValidated,
                              );
                            },
                          ),
                        ),
                        10.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ).padHorizontal,
          ),
        );
      },
    );
  }
}
