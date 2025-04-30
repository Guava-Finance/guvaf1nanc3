import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';

class BalanceText extends StatelessWidget {
  const BalanceText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final balanceAsync = ref.watch(balanceUsecaseProvider);

        return balanceAsync.when(
          data: (data) {
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Balance: ',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '${data.symbol}${data.localBalance.formatAmount()}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: data.localBalance.formatDecimal,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.washedTextColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
          error: (e, _) {
            return 0.verticalSpace;
          },
          loading: () {
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Balance: ',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '***',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '.**',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: BrandColors.washedTextColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
