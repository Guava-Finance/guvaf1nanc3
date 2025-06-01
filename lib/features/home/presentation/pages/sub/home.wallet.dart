import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/services/pubnub.dart';
import 'package:guava/core/resources/services/wallet_connection.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:showcaseview/showcaseview.dart';

class WalletDetails extends ConsumerStatefulWidget {
  const WalletDetails({super.key});

  @override
  ConsumerState<WalletDetails> createState() => _WalletDetailsState();
}

class _WalletDetailsState extends ConsumerState<WalletDetails> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(walletAddressProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 10.w,
          ),
          decoration: ShapeDecoration(
            color: BrandColors.containerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Main Wallet',
            style: context.medium.copyWith(
              color: BrandColors.textColor,
              fontSize: 12.sp,
            ),
          ),
        ),
        Showcase(
          key: walletDetailWidgetKey,
          description: 'Click to copy your wallet address',
          child: Consumer(
            builder: (context, ref, _) {
              final publicKey = ref.watch(connectedWalletPublicKeyProvider);

              return InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.h,
                    horizontal: 10.w,
                  ),
                  decoration: ShapeDecoration(
                    color: BrandColors.containerColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        (publicKey?.toBase58() ?? '').toMaskedFormat(),
                        style: context.medium.copyWith(
                          color: BrandColors.washedTextColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).padHorizontal;
  }
}
