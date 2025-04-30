import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/entities/recent_wallet_transfer.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:intl/intl.dart';

class TransferTile extends StatelessWidget {
  const TransferTile({
    required this.data,
    super.key,
  });

  final RecentWalletTransfer data;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Text(
                data.username.isEmpty
                    ? data.address.toMaskedFormat()
                    : data.username,
                style: context.medium.copyWith(
                  color: BrandColors.light,
                  fontSize: 12.sp,
                ),
              ),
              5.verticalSpace,
              Text(
                '''Used ${DateFormat.yMMMEd().add_jmv().format(data.lastTransferAt)}''',
                style: context.medium.copyWith(
                  color: BrandColors.washedTextColor,
                  fontSize: 12.w,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
