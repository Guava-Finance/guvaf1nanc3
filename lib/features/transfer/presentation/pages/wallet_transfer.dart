import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/resources/util/debouncer.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/domain/usecases/resolve_address.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/pages/sub/address_book.dart';
import 'package:guava/features/transfer/presentation/pages/sub/recent_transfers.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';

class WalletTransfer extends ConsumerStatefulWidget {
  const WalletTransfer({
    this.walletAddress,
    super.key,
  });

  final String? walletAddress;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletTransferState();
}

class _WalletTransferState extends ConsumerState<WalletTransfer> with Loader {
  final debounce = Debouncer(duration: Duration(seconds: 2));
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(receipentAddressProvider.notifier).state = widget.walletAddress;

      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void query() {
    withLoading(() async {
      await ref.read(transferNotifierProvider).resolveAddress(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextfield(
          hintText: 'To: username or address',
          controller: controller,
          onChanged: (p0) {
            ref.read(receipentAddressProvider.notifier).state = null;

            if ((p0 ?? '').length > 2) {
              debounce.run(() => query());
            }
          },
          onSubmit: (p0) {
            query();
          },
          suffixIcon: GestureDetector(
            onTap: () async {
              try {
                // Use the proper Flutter clipboard API pattern
                final clipboardData =
                    await Clipboard.getData(Clipboard.kTextPlain);

                // Check if clipboard has valid text content
                if (clipboardData != null &&
                    clipboardData.text != null &&
                    clipboardData.text!.isNotEmpty) {
                  // Set the text and trigger the onChanged callback
                  controller.text = clipboardData.text!;

                  // Manually trigger resolveAddress if needed
                  if (controller.text.length > 2) {
                    // Move cursor to the end of the text
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );

                    // Delay slightly to ensure controller update is complete
                    Future.delayed(const Duration(milliseconds: 50), () {
                      query();
                    });
                  }
                } else {
                  // Show clipboard empty notification using the current context
                  navkey.currentContext!.notify.addNotification(
                    NotificationTile(
                      notificationType: NotificationType.warning,
                      content: 'Clipboard is empty',
                      duration: 2,
                    ),
                  );
                }
              } catch (e) {
                // Show error notification
                navkey.currentContext!.notify.addNotification(
                  NotificationTile(
                    notificationType: NotificationType.error,
                    content: 'Failed to access clipboard: ${e.toString()}',
                    duration: 2,
                  ),
                );
              }
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
        ).padHorizontal,
        10.verticalSpace,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                10.verticalSpace,
                RecentTransfers(),
                20.verticalSpace,
                AddressBook(),
                20.verticalSpace,
              ],
            ),
          ),
        ),
        Divider(color: BrandColors.washedTextColor.withValues(alpha: .3)),
        12.verticalSpace,
        ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, snapshot, child) {
            return Consumer(
              builder: (context, ref, child) {
                final result = ref.watch(receipentAddressProvider);

                return CustomButton(
                  onTap: () {
                    context.push(pEnterAmountWallet);
                  },
                  title: 'Next',
                  disable: result == null,
                  isLoading: snapshot,
                ).padHorizontal;
              },
            );
          },
        ),
        30.verticalSpace,
      ],
    );
  }
}
