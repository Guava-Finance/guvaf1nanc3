import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/notifier/account.notifier.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/page_indicator.dart';

class MnemonicBackupValidationPage extends ConsumerStatefulWidget {
  const MnemonicBackupValidationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MnemonicBackupValidationPageState();
}

class _MnemonicBackupValidationPageState
    extends ConsumerState<MnemonicBackupValidationPage> {
  bool _isValidating = false;
  final String _validationMessage = '';
  final bool _validationSuccess = false;

  @override
  void initState() {
    super.initState();
    // Clear any previously selected words
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedWordsProvider.notifier).state = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final validationIndices = ref.watch(validationIndicesProvider);
    final selectedWords = ref.watch(selectedWordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: PageIndicator(
          totalPages: 4,
          currentPage: 3,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Recovery phrase verification',
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Text(
            '''Please tap on the ${validationIndices.map((i) => ordinal(i)).join(', ')} word${validationIndices.length > 1 ? 's' : ''} of your recovery phrase to verify.''',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.washedTextColor,
              fontSize: 12.sp,
            ),
          ),
          // if (_validationMessage.isNotEmpty) ...[
          //   16.verticalSpace,
          //   Text(
          //     _validationMessage,
          //     textAlign: TextAlign.center,
          //     style: context.textTheme.bodyMedium?.copyWith(
          //       color: _validationSuccess ? Colors.green : Colors.red,
          //       fontSize: 14.sp,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ],
          30.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              final mnemonic = ref.watch(myMnenomics);

              return mnemonic.when(
                data: (m) {
                  final phrase = m.split(' ');
                  // Shuffle the display order but keep track of original indices
                  final displayOrder = List.generate(phrase.length, (i) => i)
                    ..shuffle();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: BrandColors.containerColor,
                          ),
                        ),
                        child: Wrap(
                          runSpacing: 5.sp,
                          spacing: 5.sp,
                          children: [
                            for (var displayIndex = 0;
                                displayIndex < displayOrder.length;
                                displayIndex++) ...{
                              Builder(
                                builder: (context) {
                                  final originalIndex =
                                      displayOrder[displayIndex];
                                  final isSelected =
                                      selectedWords.contains(originalIndex);

                                  return GestureDetector(
                                    onTap: _isValidating
                                        ? null
                                        : () => _handleWordTap(originalIndex),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.r),
                                        color: isSelected
                                            ? BrandColors.lightGreen
                                            : BrandColors.containerColor,
                                        border: isSelected
                                            ? Border.all(
                                                color: isSelected
                                                    ? BrandColors.lightGreen
                                                    : Colors.transparent,
                                              )
                                            : null,
                                      ),
                                      child: Text(
                                        phrase[originalIndex],
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontSize: 14.sp,
                                          color: isSelected
                                              ? BrandColors.backgroundColor
                                              : null,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            },
                          ],
                        ),
                      ),
                    ],
                  );
                },
                error: (_, __) {
                  return 0.verticalSpace;
                },
                loading: () {
                  return 0.verticalSpace;
                },
              );
            },
          ),
        ],
      ).padHorizontal,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onTap: () => _isValidating ? null : _validateSelection(),
            title: _isValidating ? 'Validating...' : 'Confirm',
            disable: _isValidating,
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }

  void _handleWordTap(int wordIndex) {
    final selectedWords = ref.read(selectedWordsProvider);

    if (selectedWords.contains(wordIndex)) {
      // Deselect the word
      ref.read(selectedWordsProvider.notifier).state = Set.from(selectedWords)
        ..remove(wordIndex);
    } else {
      // Select the word
      ref.read(selectedWordsProvider.notifier).state = Set.from(selectedWords)
        ..add(wordIndex);
    }
  }

  void _validateSelection() {
    final validationIndices = ref.read(validationIndicesProvider);
    final selectedWords = ref.read(selectedWordsProvider);

    // Convert validation indices from 1-based to 0-based for comparison
    final requiredIndices = validationIndices.map((i) => i - 1).toSet();

    setState(() {
      _isValidating = true;
    });

    // Simulate validation delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      final success = setEquals(selectedWords, requiredIndices);

      if (success) {
        // Navigate to the next screen after short delay
        Future.delayed(const Duration(milliseconds: 700), () async {
          await ref.watch(accountNotifierProvider).hasBackedUpPhrase();
          // Navigate to the next page in the flow
          // navkey.currentContext!.push(pMnenomicBackupComplete);
          navkey.currentContext!.go(pDashboard);
          navkey.currentContext!.notify.addNotification(
            NotificationTile(
              content: 'Backup Verification success...',
              notificationType: NotificationType.success,
            ),
          );
        });
      } else {
        navkey.currentContext!.notify.addNotification(
          NotificationTile(
            content: 'Incorrect selection. Please try again.',
            notificationType: NotificationType.error,
          ),
        );
      }
    });
  }

  // Helper function for displaying ordinal numbers
  String ordinal(int number) {
    if (number == 1) return '1st';
    if (number == 2) return '2nd';
    if (number == 3) return '3rd';
    return '${number}th';
  }
}
