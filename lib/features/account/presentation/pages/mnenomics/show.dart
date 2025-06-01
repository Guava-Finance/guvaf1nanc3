import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/notifier/account.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/page_indicator.dart';

class ShowMnenomicsPage extends ConsumerStatefulWidget {
  const ShowMnenomicsPage({
    this.isBackUp = false,
    super.key,
  });

  final bool isBackUp;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowMnenomicsPageState();
}

class _ShowMnenomicsPageState extends ConsumerState<ShowMnenomicsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(firebaseAnalyticsProvider)
          .triggerScreenLogged(runtimeType.toString());

      if (!widget.isBackUp) {
        navkey.currentContext!.mixpanel.track(
          MixpanelEvents.seedPhraseViewed,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageIndicator(
          totalPages: 4,
          currentPage: 2,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your recovery phrase',
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Text(
            '''Recovery phrase is a way to access your wallet. Write\ndown or copy these words in this exact order and\nkeep them in a safe place.''',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.washedTextColor,
              fontSize: 12.sp,
            ),
          ),
          30.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              final mnemonic = ref.watch(myMnenomics);

              return mnemonic.when(
                data: (m) {
                  final phrase = m.split(' ');

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
                            for (var i = 0; i < phrase.length; i++) ...{
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: BrandColors.containerColor,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: '${i + 1}. '),
                                          TextSpan(text: phrase[i]),
                                        ],
                                      ),
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                      12.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: m)).then(
                            (v) {
                              navkey.currentContext!.notify.addNotification(
                                NotificationTile(
                                  content: 'Secret phrase copied',
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIcon(
                                icon: R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG),
                            8.horizontalSpace,
                            Text(
                              'Copy to clipboard',
                              style: context.textTheme.bodyMedium,
                            ),
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
      bottomNavigationBar: widget.isBackUp
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  onTap: () {
                    final mnemonic = ref.read(myMnenomics).valueOrNull;
                    if (mnemonic != null) {
                      final phraseLength = mnemonic.split(' ').length;
                      final requiredCount = phraseLength == 24
                          ? 8
                          : 4; // 8 words for 24-word phrase, 4 for 12-word

                      final indices = ref
                          .read(accountNotifierProvider)
                          .generateRandomIndices(phraseLength, requiredCount);

                      ref.read(validationIndicesProvider.notifier).state =
                          indices;

                      context.push(pMnenomicValidation);
                    }
                  },
                  title: 'I have safely stored my key-phrase',
                ),
                30.verticalSpace,
              ],
            ).padHorizontal
          : null,
    );
  }
}
