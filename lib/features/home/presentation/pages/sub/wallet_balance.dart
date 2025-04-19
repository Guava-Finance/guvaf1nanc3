import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:intl/intl.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        Consumer(
          builder: (context, ref, _) {
            final balanceAsync = ref.watch(balanceUsecaseProvider);
            final isVisible = ref.watch(isBalanceVisibleProvider);

            final cryptoCurrency = NumberFormat.currency(
              symbol: '',
              decimalDigits: 0,
            );

            return balanceAsync.when(
              error: (error, stackTrace) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: cryptoCurrency.format(0),
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: BrandColors.textColor,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // todo: fix decimal part
                            TextSpan(
                              text: cryptoCurrency.format(0),
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
                            text: cryptoCurrency.format(0),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: BrandColors.textColor,
                            ),
                          ),
                          TextSpan(
                            text: cryptoCurrency.format(0),
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
                );
              },
              loading: () {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: '***',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: BrandColors.textColor,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // todo: fix decimal part
                            TextSpan(
                              text: '.**',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: BrandColors.washedTextColor,
                                fontSize: 36.sp,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '***',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: BrandColors.textColor,
                            ),
                          ),
                          TextSpan(
                            text: '.**',
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
                );
              },
              data: (data) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IntrinsicWidth(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: isVisible
                                    // ignore: lines_longer_than_80_chars
                                    ? '${data.symbol}${data.localBalance.formatAmount()}'
                                    : '****',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: BrandColors.textColor,
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // todo: fix decimal part
                              TextSpan(
                                text: isVisible
                                    ? (data.localBalance).formatDecimal
                                    : '.**',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: BrandColors.washedTextColor,
                                  fontSize: 36.sp,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        10.horizontalSpace,
                        IconButton(
                          onPressed: () {
                            ref.read(isBalanceVisibleProvider.notifier).state =
                                !isVisible;

                            // ref
                            //     .read(dashboardNotifierProvider)
                            //     .toggleShowBalance(
                            //       !isVisible,
                            //     );
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                            color: BrandColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: isVisible
                                ? data.usdcBalance.formatAmount()
                                : '**',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: BrandColors.textColor,
                            ),
                          ),
                          TextSpan(
                            text: isVisible
                                ? (data.usdcBalance).formatDecimal
                                : '.**',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: BrandColors.washedTextColor,
                            ),
                          ),
                          TextSpan(
                            text: isVisible ? ' USDC' : '',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: BrandColors.washedTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    ).padHorizontal;
  }
}
