import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/entities/bank_beneficiary.dart';
import 'package:guava/features/transfer/domain/entities/recent_bank_transfer.dart';
import 'package:guava/widgets/app_icon.dart';

class RecentsBankTransferTile<T> extends StatelessWidget {
  const RecentsBankTransferTile({
    required this.data,
    this.onTap,
    super.key,
  });

  final T data;
  final Function(T)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(data);
      },
      child: Row(
        children: [
          CustomIcon(
            icon: R.ASSETS_ICONS_NIGERIA_FLAG_SVG,
            height: 30.h,
            width: 30.w,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (data is RecentBankTransfer)
                      ? (data as RecentBankTransfer).accountName
                      : (data as BankBeneficiary).accountName,
                  style: context.medium.copyWith(
                    color: BrandColors.light,
                    fontSize: 14.sp,
                  ),
                ),
                5.verticalSpace,
                Text(
                  '''${(data is RecentBankTransfer) ? (data as RecentBankTransfer).accountNumber : (data as BankBeneficiary).accountNumber} (${(data is RecentBankTransfer) ? (data as RecentBankTransfer).bank : (data as BankBeneficiary).bank})''',
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
    );
  }
}
