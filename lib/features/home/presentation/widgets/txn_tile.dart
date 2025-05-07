import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/entities/transaction_history.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:intl/intl.dart';

final selectedTransactionHistory = StateProvider<TransactionsHistory?>((ref) {
  return null;
});

class TransactionHistoryTile extends ConsumerWidget {
  const TransactionHistoryTile({
    required this.data,
    super.key,
  });

  final TransactionsHistory data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hn = ref.watch(homeNotifierProvider);

    final currency = NumberFormat.currency(
      symbol: '',
      decimalDigits: 2,
    );

    return GestureDetector(
      onTap: () {
        ref.read(selectedTransactionHistory.notifier).state = data;

        context.push(pTransactionDetail, extra: data);
        HapticFeedback.lightImpact();
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  maxRadius: 20.r,
                  backgroundColor: BrandColors.lightGreen,
                  child: CustomIcon(
                    icon: R.ASSETS_ICONS_WALLET_ICON_SVG,
                    color: BrandColors.backgroundColor,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            if (data.category == 'debit') ...{
                              TextSpan(text: 'Transfer to '),
                              TextSpan(
                                text: data.recipient?.toMaskedFormat(),
                                style: context.medium.copyWith(
                                  color: BrandColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.w,
                                ),
                              ),
                            } else ...{
                              TextSpan(text: 'Transfer from '),
                              TextSpan(
                                text: data.sender?.toMaskedFormat(),
                              ),
                            }
                          ],
                        ),
                        style: context.medium.copyWith(
                          color: BrandColors.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.w,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.verticalSpace,
                      Row(
                        children: [
                          Text(
                            DateFormat('MMM dd').format(
                              data.timestamp ?? DateTime.now(),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: context.medium.copyWith(
                              color: BrandColors.washedTextColor,
                              fontSize: 10.sp,
                            ),
                          ),
                          Container(
                            width: 1.w,
                            height: 10.h,
                            color: BrandColors.washedTextColor
                                .withValues(alpha: 0.3),
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                          ),
                          Text(
                            DateFormat.jmv()
                                .format(data.timestamp ?? DateTime.now()),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: context.medium.copyWith(
                              color: BrandColors.washedTextColor,
                              fontSize: 10.sp,
                            ),
                          ),
                          Container(
                            width: 1.w,
                            height: 10.h,
                            color: BrandColors.washedTextColor
                                .withValues(alpha: 0.3),
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                          ),
                          Text(
                            (data.type ?? '').toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: context.medium.copyWith(
                              color: BrandColors.washedTextColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                8.horizontalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 8.w,
                  ),
                  decoration: ShapeDecoration(
                    color: hn.txnColor(data.status).withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: hn.txnColor(data.status).withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Text(
                    data.status ?? '',
                    style: context.medium.copyWith(
                      color: hn.txnColor(data.status),
                      fontSize: 8.sp,
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: -1.h,
              right: 0.w,
              child: FutureBuilder(
                future: ref.read(balanceUsecaseProvider.future),
                builder: (_, ss) {
                  if (ss.data == null) {
                    return 0.verticalSpace;
                  }

                  return IntrinsicWidth(
                    child: Text(
                      '''${ss.data!.symbol}${currency.format(data.type == 'bank' ? (data.amount ?? 0.0) : ((data.amount ?? 0.0) / ss.data!.exchangeRate))}''',
                      style: context.medium.copyWith(
                        color: Colors.white,
                        fontSize: 13.w,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
