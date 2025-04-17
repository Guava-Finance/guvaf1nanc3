import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/payment_item.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/utility_widget.dart';

class BankRecieve extends ConsumerStatefulWidget {
  const BankRecieve({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BankRecieveState();
}

class _BankRecieveState extends ConsumerState<BankRecieve> {
  late final TextEditingController controller;
  bool isSwitched = false;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How much are you funding your wallet?',
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: BrandColors.textColor,
            fontSize: 16.sp,
          ),
        ),
        15.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
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
                controller: controller,
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
                        vertical: 3.h,
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
              TextFormField(
                controller: controller,
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
                        vertical: 3.h,
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
            ],
          ),
        ),
        10.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Include fee',
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: BrandColors.textColor,
                ),
              ),
              Container(
                width: 35.w,
                height: 20.w,
                decoration: ShapeDecoration(
                  color: hexColor('7A7A7A'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                child: FlutterSwitch(
                  borderRadius: 5.r,
                  toggleSize: 15,
                  padding: 3,
                  activeColor: BrandColors.washedGreen,
                  value: isSwitched,
                  onToggle: (val) => setState(
                    () {
                      isSwitched = val;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        60.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
              PaymentItem(
                title: 'Our exchange rate',
                value: '\$1 to NGN1502.00',
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
        CustomButton(onTap: () {}, title: 'Continue')
      ],
    );
  }
}
