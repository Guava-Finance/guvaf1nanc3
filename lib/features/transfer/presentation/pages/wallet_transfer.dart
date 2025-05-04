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
import 'package:showcaseview/showcaseview.dart';

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
  final debouncer = Debouncer(duration: Duration(seconds: 2));
  late final TextEditingController controller;
  bool _isDisposed = false;

  @override
  void initState() {
    controller = TextEditingController();

    // If walletAddress is provided, set it right away
    if (widget.walletAddress != null && widget.walletAddress!.isNotEmpty) {
      controller.text = widget.walletAddress!;
      // Delay query to ensure widget is fully initialized
      Future.microtask(() => query());
    }

    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    debouncer.dispose(); // Ensure the debouncer is properly disposed
    controller.dispose();
    super.dispose();
  }

  void query() {
    // Check if widget is still mounted before proceeding
    if (_isDisposed) return;

    withLoading(() async {
      // Check mounted state again before starting async operation
      if (_isDisposed) return;
      await ref.read(transferNotifierProvider).resolveAddress(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only run this once after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed) return; // Safety check

      // Use a safer approach to update the text field
      final savedAddress = ref.read(receipentAddressProvider);
      if (savedAddress != null && savedAddress.isNotEmpty && mounted) {
        Future.delayed(Durations.medium1, () {
          if (mounted && controller.text != savedAddress) {
            controller.text = savedAddress;
            setState(() {});
          }
        });
      }
    });

    return Column(
      children: [
        Showcase(
          key: recipientWidgetKey,
          description: 'Send money via username or wallet address',
          targetBorderRadius: BorderRadius.circular(16.r),
          child: CustomTextfield(
            hintText: 'To: username or address',
            controller: controller,
            onChanged: (p0) {
              if (_isDisposed) return; // Safety check

              ref.read(receipentAddressProvider.notifier).state = null;

              if ((p0 ?? '').length > 2) {
                debouncer.run(() {
                  if (!mounted)
                    return; // Safety check inside debouncer callback
                  query();
                });
              }
            },
            onSubmit: (p0) {
              if (!mounted) return; // Safety check
              query();
            },
            suffixIcon: GestureDetector(
              onTap: () async {
                if (!mounted) return; // Safety check

                try {
                  // Use the proper Flutter clipboard API pattern
                  final clipboardData =
                      await Clipboard.getData(Clipboard.kTextPlain);

                  // Verify mounted state after async operation
                  if (!mounted) return;

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
                        if (!mounted) return; // Safety check
                        query();
                      });
                    }
                  } else {
                    // Show clipboard empty notification using the current context
                    if (navkey.currentContext != null) {
                      navkey.currentContext!.notify.addNotification(
                        NotificationTile(
                          notificationType: NotificationType.warning,
                          content: 'Clipboard is empty',
                          duration: 2,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  // Verify mounted state after exception
                  if (!mounted) return;

                  // Show error notification
                  if (navkey.currentContext != null) {
                    navkey.currentContext!.notify.addNotification(
                      NotificationTile(
                        notificationType: NotificationType.error,
                        content: 'Failed to access clipboard: ${e.toString()}',
                        duration: 2,
                      ),
                    );
                  }
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
                    if (!mounted) return; // Safety check
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
