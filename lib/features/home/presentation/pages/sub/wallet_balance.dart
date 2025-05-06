// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/data/models/balance.param.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:showcaseview/showcaseview.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({super.key});

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

            return balanceAsync.when(
              error: (error, stackTrace) {
                return _buildErrorState(context, ref, isVisible);
              },
              loading: () => _buildLoadingState(context, ref, isVisible),
              data: (data) => _buildDataState(context, ref, data, isVisible),
            );
          },
        ),
      ],
    ).padHorizontal;
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, bool isVisible) {
    final cachedBalance = ref.read(cachedBalanceProivder.future);

    return FutureBuilder<Map<String, dynamic>?>(
      future: cachedBalance,
      builder: (context, snapshot) {
        return _BalanceDisplay(
          localBalance: snapshot.data?['localBalance'],
          currencySymbol: snapshot.data?['symbol'] ?? '',
          usdcBalance: snapshot.data?['usdcBalance'],
          isVisible: isVisible,
          onToggleVisibility: () => _toggleVisibility(ref, isVisible),
          isLoading: false,
        );
      },
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    WidgetRef ref,
    bool isVisible,
  ) {
    return _BalanceDisplay(
      isVisible: isVisible,
      onToggleVisibility: () => _toggleVisibility(ref, isVisible),
      isLoading: true,
    );
  }

  Widget _buildDataState(
    BuildContext context,
    WidgetRef ref,
    BalanceParam data,
    bool isVisible,
  ) {
    return _BalanceDisplay(
      localBalance: data.localBalance,
      currencySymbol: data.symbol,
      usdcBalance: data.usdcBalance,
      isVisible: isVisible,
      onToggleVisibility: () => _toggleVisibility(ref, isVisible),
      isLoading: false,
    );
  }

  void _toggleVisibility(WidgetRef ref, bool isVisible) {
    ref.read(isBalanceVisibleProvider.notifier).state = !isVisible;
  }
}

class _BalanceDisplay extends ConsumerWidget {
  const _BalanceDisplay({
    required this.isVisible,
    required this.onToggleVisibility,
    required this.isLoading,
    this.localBalance,
    this.currencySymbol = '',
    this.usdcBalance,
  });

  final double? localBalance;
  final String currencySymbol;
  final double? usdcBalance;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Showcase(
          key: balanceWidgetKey,
          description: 'See your wallet balance in your local currency',
          targetPadding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              IntrinsicWidth(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _getLocalBalanceText(),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: BrandColors.textColor,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: _getLocalBalanceDecimalText(),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: BrandColors.washedTextColor,
                          fontSize: 36.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: onToggleVisibility,
                icon: isLoading
                    ? CupertinoActivityIndicator(
                        color: BrandColors.primary,
                        radius: 12.r,
                      )
                    : Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        color: BrandColors.textColor,
                      ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: _getUsdcBalanceText(),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.textColor,
                ),
              ),
              TextSpan(
                text: _getUsdcBalanceDecimalText(),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.washedTextColor,
                ),
              ),
              TextSpan(
                text: _getUsdcSuffixText(),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.washedTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getLocalBalanceText() {
    if (isLoading) return '***';
    if (localBalance == null) return 'nil';
    return isVisible
        ? '$currencySymbol${localBalance!.formatAmount()}'
        : '****';
  }

  String _getLocalBalanceDecimalText() {
    if (isLoading) return '.**';
    if (localBalance == null) return '';
    return isVisible ? localBalance!.formatDecimal : '.**';
  }

  String _getUsdcBalanceText() {
    if (isLoading) return '***';
    if (usdcBalance == null) return 'nil';
    return isVisible ? usdcBalance!.formatAmount() : '**';
  }

  String _getUsdcBalanceDecimalText() {
    if (isLoading) return '.**';
    if (usdcBalance == null) return '';
    return isVisible ? usdcBalance!.formatDecimal : '.**';
  }

  String _getUsdcSuffixText() {
    if (usdcBalance == null) return '';
    return isVisible ? ' USDC' : '';
  }
}
