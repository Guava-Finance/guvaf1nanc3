import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/pages/sub/address_book.dart';
import 'package:guava/features/transfer/presentation/pages/sub/recent_transfers.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';

class WalletTransfer extends ConsumerStatefulWidget {
  const WalletTransfer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletTransferState();
}

class _WalletTransferState extends ConsumerState<WalletTransfer> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  final notifier = ref.watch(transferNotifierProvider.notifier);

    return Column(
      children: [
        CustomTextfield(
          hintText: 'To: username or address',
          controller: controller,
          suffixIcon: GestureDetector(
            onTap: () {
              Clipboard.getData('text/plain').then((e) {
                if (e != null) {
                  controller.value = TextEditingValue(
                    text: e.text ?? '',
                  );
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 6.h,
                horizontal: 10.w,
              ),
              decoration: ShapeDecoration(
                color: BrandColors.containerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'Paste',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: BrandColors.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ),
        20.verticalSpace,
        RecentTransfers(),
        20.verticalSpace,
        AddressBook(),
        20.verticalSpace,
        Divider(
          color: BrandColors.washedTextColor.withValues(alpha: .3),
        ),
        15.verticalSpace,
        CustomButton(
          onTap: () {
            context.push(pEnterAmountWallet);
          },
          title: 'Next',
        ).padHorizontal,
        15.verticalSpace,
      ],
    );
  }
}
