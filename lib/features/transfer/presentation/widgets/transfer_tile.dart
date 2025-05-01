import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/entities/recent_wallet_transfer.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:intl/intl.dart';

class TransferTile extends ConsumerWidget {
  const TransferTile({
    required this.data,
    super.key,
  });

  final RecentWalletTransfer data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(receipentAddressProvider.notifier).state = data.address;
        context.push(pEnterAmountWallet);
      },
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            CircleAvatar(
              maxRadius: 20.r,
              backgroundColor: BrandColors.lightGreen.withValues(alpha: .7),
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
                  Text(
                    data.username.isEmpty
                        ? data.address.toMaskedFormat(
                            prefixLength: 4,
                            maskLength: 8,
                            suffixLength: 4,
                          )
                        : data.username,
                    style: context.medium.copyWith(
                      color: BrandColors.light,
                      fontSize: 12.sp,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    DateFormat.yMMMEd().add_jmv().format(data.lastTransferAt),
                    style: context.medium.copyWith(
                      color: BrandColors.washedTextColor,
                      fontSize: 12.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
