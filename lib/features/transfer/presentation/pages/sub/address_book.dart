import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/usecases/address_book.dart';
import 'package:guava/features/transfer/presentation/widgets/address_tile.dart';

class AddressBook extends StatelessWidget {
  const AddressBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(R.ASSETS_ICONS_ADDRESS_BOOK_SVG),
            10.horizontalSpace,
            Text(
              'Address book',
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: BrandColors.washedTextColor,
              ),
            )
          ],
        ),
        10.verticalSpace,
        Consumer(
          builder: (context, ref, child) {
            final addresses = ref.watch(myAddressBook);

            return addresses.when(
              data: (data) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 15.w,
                  ),
                  decoration: ShapeDecoration(
                    // color: BrandColors.containerColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: (data ?? []).isEmpty
                      ? Text(
                          'No address saved',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: BrandColors.washedTextColor,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data!.take(5).length,
                          separatorBuilder: (ctx, i) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Divider(
                              color: BrandColors.washedTextColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          itemBuilder: (ctx, i) {
                            return AddressTile(
                              data: data[i],
                            );
                          },
                        ),
                );
              },
              error: (_, __) {
                return 0.verticalSpace;
              },
              loading: () {
                return Center(
                  child: CupertinoActivityIndicator(
                    radius: 12.r,
                    color: BrandColors.primary,
                  ),
                );
              },
            );
          },
        )
      ],
    ).padHorizontal;
  }
}
