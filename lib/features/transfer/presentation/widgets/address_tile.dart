import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/entities/address_book.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    required this.data,
    super.key,
  });

  final WalletAddressBook data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          maxRadius: 20.r,
          backgroundColor: BrandColors.lightGreen,
          child: Center(
            child: Text(
              data.username.split('').first.toUpperCase(),
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: BrandColors.backgroundColor,
              ),
            ),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${data.username}',
                style: context.medium.copyWith(
                  color: BrandColors.light,
                  fontSize: 14.sp,
                ),
              ),
              5.verticalSpace,
              Text(
                data.address.toMaskedFormat(),
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
