import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/services/config.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/features/home/presentation/widgets/token_info.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';

class OtherAssets extends ConsumerWidget {
  const OtherAssets({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            AppLogger.log(ref.read(splTokenAccounts).length);
          },
          child: Text(
            'Other assets',
            style: context.medium.copyWith(
              color: BrandColors.textColor,
              fontSize: 16.w,
            ),
          ),
        ),
        12.verticalSpace,
        Showcase(
          key: otherAssetsWidgetKey,
          description: 'Show all token accounts that the wallet has',
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            decoration: ShapeDecoration(
              color: BrandColors.containerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final assetsAsyn = ref.watch(allAssetBalance);

                return assetsAsyn.when(
                  data: (data) {
                    return data.isEmpty
                        ? Center(
                            child: Text(
                              'No assets found',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                color: BrandColors.washedTextColor,
                              ),
                            ),
                          )
                        : ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                onTap: () {
                                  if (data[i].splToken != null) {
                                    SplTokenInfo(
                                      splToken: data[i].splToken!,
                                    ).bottomSheet;
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  maxRadius: 20.r,
                                  backgroundImage: data[i].splToken != null
                                      ? NetworkImage(data[i].splToken!.logoURI)
                                      : null,
                                  backgroundColor: BrandColors.backgroundColor,
                                  child: data[i].splToken == null
                                      ? Icon(
                                          Icons.help,
                                          color: BrandColors.washedTextColor,
                                        )
                                      : null,
                                ),
                                title: Text(
                                  data[i].splToken?.name ?? 'Unknown Token',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Text(
                                  '''${NumberFormat.currency(symbol: '').format(data[i].amount)} ${data[i].splToken?.symbol ?? 'null'}''',
                                  style: context.textTheme.bodyMedium,
                                ),
                              );
                            },
                            separatorBuilder: (ctx, i) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Divider(
                                color: BrandColors.washedTextColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            itemCount: data.length,
                          );
                  },
                  error: (_, __) => Center(
                    child: Text(
                      'No assets found',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        color: BrandColors.washedTextColor,
                      ),
                    ),
                  ),
                  loading: () => CupertinoActivityIndicator(
                    radius: 16.r,
                    color: BrandColors.primary,
                  ),
                );
              },
            ),
          ),
        )
      ],
    ).padHorizontal;
  }
}
