import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/entities/address_book.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';

class AddressTile extends ConsumerWidget {
  const AddressTile({
    required this.data,
    super.key,
  });

  final WalletAddressBook data;

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
              child: Center(
                child: Text(
                  data.username.isEmpty
                      ? ''
                      : data.username.split('').first.toUpperCase(),
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
                    data.label,
                    style: context.medium.copyWith(
                      color: BrandColors.light,
                      fontSize: 14.sp,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    data.address.toMaskedFormat(maskLength: 8),
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
