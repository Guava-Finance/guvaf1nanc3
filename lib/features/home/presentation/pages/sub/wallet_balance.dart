import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:intl/intl.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    final cryptoCurrency = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Balance',
          style: context.textTheme.bodyMedium?.copyWith(
            color: BrandColors.washedTextColor,
            fontSize: 14.sp,
          ),
        ),
        Row(
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: currency.format(3000.54),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: BrandColors.textColor,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // todo: fix decimal part
                TextSpan(
                  text: (3000.54).decimalPart,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: BrandColors.washedTextColor,
                    fontSize: 36.sp,
                  ),
                ),
              ]),
            ),
            10.horizontalSpace,
            Icon(
              Icons.visibility,
              color: BrandColors.textColor,
            ),
          ],
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: cryptoCurrency.format(10.54),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.textColor,
                ),
              ),
              TextSpan(
                text: (10.54).decimalPart,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.washedTextColor,
                ),
              ),
              TextSpan(
                text: ' USDC',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.washedTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ).padHorizontal;
  }
}
