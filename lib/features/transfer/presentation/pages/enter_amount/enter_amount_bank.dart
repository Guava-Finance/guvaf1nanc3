import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/onboarding/presentation/widgets/number_pad.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class EnterAmountBank extends ConsumerStatefulWidget {
  const EnterAmountBank({
    this.onComplete,
    this.subtitle,
    this.title,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Function(String)? onComplete;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterAmountWalletState();
}

class _EnterAmountWalletState extends ConsumerState<EnterAmountBank> {
  late final TextEditingController pinCtrl;
  late final TextEditingController controller;

  @override
  void initState() {
    pinCtrl = TextEditingController();
    controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    pinCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Text(
                'Enter amount',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: BrandColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: BrandColors.containerColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(R.ASSETS_ICONS_CLOSE_SVG),
                        ),
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
                CustomTextfield(
                  hintText: 'To: username or address',
                  controller: controller,
                  // suffixIcon: GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //       vertical: 6.h,
                  //       horizontal: 10.w,
                  //     ),
                  //     decoration: ShapeDecoration(
                  //       color: BrandColors.containerColor,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16.r),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Edit',
                  //       style: context.textTheme.bodyMedium!.copyWith(
                  //         color: BrandColors.textColor,
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 12.sp,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                5.verticalSpace,
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'Balance: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // todo: fix decimal part
                    TextSpan(
                      text: currency.format(120000),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    TextSpan(
                      text: (120000.98).decimalPart,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.washedTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ]),
                ).padHorizontal,
                40.verticalSpace,
                TextFormField(
                  controller: pinCtrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: currency.format(0.00),
                    hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.washedTextColor,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.light,
                  ),
                  textAlign: TextAlign.center,
                ).padHorizontal,
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 8.w,
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
                                  text: '0',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: BrandColors.textColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: '${(0.00).decimalPart} USDC',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: BrandColors.washedTextColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ]),
                            ),
                            7.horizontalSpace,
                            SvgPicture.asset(R.ASSETS_ICONS_EXCHANGE_SVG)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                CustomNumberPad(
                  controller: pinCtrl,
                  isAmountPad: true,
                ),
                40.verticalSpace,
                CustomButton(onTap: () {}, title: 'Send'),
                40.verticalSpace,
              ],
            ).padHorizontal,
          ],
        ),
      ),
    );
  }
}
