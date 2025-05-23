import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/data/models/spl_token.dart';
import 'package:url_launcher/url_launcher.dart';

class SplTokenInfo extends ConsumerWidget {
  const SplTokenInfo({
    required this.splToken,
    super.key,
  });

  final SplToken splToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Symbol',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Text(
                splToken.symbol,
                textAlign: TextAlign.end,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Divider(
            color: BrandColors.washedTextColor.withValues(
              alpha: 0.3,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              'Network',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Text(
                'Solana',
                textAlign: TextAlign.end,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Divider(
            color: BrandColors.washedTextColor.withValues(
              alpha: 0.3,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              'Mint',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Text(
                splToken.address.toMaskedFormat(),
                textAlign: TextAlign.end,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: BrandColors.textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Divider(
            color: BrandColors.washedTextColor.withValues(
              alpha: 0.3,
            ),
          ),
        ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  String url = '';
                  if (splToken.chainId == 101) {
                    url = 'https://solscan.io/account/${splToken.address}';
                  } else {
                    url =
                        'https://solscan.io/account/${splToken.address}?cluster=devnet';
                  }

                  launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text(
                  'View on Solscan',
                  textAlign: TextAlign.end,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: BrandColors.washedTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        60.verticalSpace,
      ],
    ).padHorizontal;
  }
}
