import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/firebase/analytics.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/double.dart';
import 'package:guava/core/resources/extensions/string.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/notification/wrapper/tile.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/domain/usecases/balance.dart';
import 'package:guava/features/home/domain/usecases/history.dart';
import 'package:guava/features/receive/presentation/notifier/countdown.notifier.dart';
import 'package:guava/features/receive/presentation/notifier/recieve.notifier.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';

class AccountPayablePage extends ConsumerStatefulWidget {
  const AccountPayablePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountPayablePageState();
}

class _AccountPayablePageState extends ConsumerState<AccountPayablePage> {
  bool iAgree = false;

  @override
  Widget build(BuildContext context) {
    ref
        .read(firebaseAnalyticsProvider)
        .triggerScreenLogged(runtimeType.toString());

    final amount = ref.watch(localAountTransfer);

    return Scaffold(
      appBar: AppBar(title: Text('Receive')),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            30.verticalSpace,
            CustomIcon(
              icon: R.ASSETS_ICONS_BANK_SVG,
            ),
            24.verticalSpace,
            IntrinsicWidth(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Pay '),
                    TextSpan(text: amount.formatAmount()),
                    TextSpan(
                      text: amount.formatDecimal,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 18.sp,
                        color: BrandColors.washedTextColor,
                      ),
                    ),
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: amount.toString()),
                          ).then((v) {
                            navkey.currentContext!.notify.addNotification(
                              NotificationTile(
                                content: 'Amount copied',
                                duration: 2,
                              ),
                            );
                          });
                        },
                        child: CustomIcon(
                          icon: R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG,
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    )
                  ],
                ),
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  color: BrandColors.textColor,
                ),
              ),
            ),
            24.verticalSpace,
            Consumer(
              builder: (context, ref, child) {
                final payable = ref.watch(accountPayable);

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: BrandColors.containerColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: BrandColors.washedTextColor.withValues(alpha: .3),
                      width: .5.w,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Account number\n',
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 12.sp,
                                      color: BrandColors.washedTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(text: payable?.accountNumber),
                                  TextSpan(text: '  '),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                              text:
                                                  (payable?.accountNumber ?? '')
                                                      .toString()),
                                        ).then((v) {
                                          navkey.currentContext!.notify
                                              .addNotification(
                                            NotificationTile(
                                              content: 'Account number copied',
                                              duration: 2,
                                            ),
                                          );
                                        });
                                      },
                                      child: CustomIcon(
                                        icon:
                                            R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG,
                                        width: 14.w,
                                        height: 14.h,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              textAlign: TextAlign.start,
                              style: context.textTheme.titleLarge?.copyWith(
                                fontSize: 14.sp,
                                color: BrandColors.textColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Bank\n',
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 12.sp,
                                      color: BrandColors.washedTextColor,
                                    ),
                                  ),
                                  TextSpan(text: payable?.bankName),
                                  TextSpan(text: ' '),
                                ],
                              ),
                              textAlign: TextAlign.end,
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: BrandColors.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      Divider(
                        color:
                            BrandColors.washedTextColor.withValues(alpha: .3),
                      ),
                      12.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Account name\n',
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 12.sp,
                                      color: BrandColors.washedTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(text: payable?.accountName),
                                ],
                              ),
                              textAlign: TextAlign.start,
                              style: context.textTheme.titleLarge?.copyWith(
                                fontSize: 14.sp,
                                color: BrandColors.textColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Reference\n',
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 12.sp,
                                      color: BrandColors.washedTextColor,
                                    ),
                                  ),
                                  TextSpan(
                                      text: (payable?.reference ?? '')
                                          .toMaskedFormat()),
                                  TextSpan(text: ' '),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                              text: (payable?.reference ?? '')
                                                  .toString()),
                                        ).then((v) {
                                          navkey.currentContext!.notify
                                              .addNotification(
                                            NotificationTile(
                                              content: 'Reference copied',
                                              duration: 2,
                                            ),
                                          );
                                        });
                                      },
                                      child: CustomIcon(
                                        icon:
                                            R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG,
                                        width: 14.w,
                                        height: 14.h,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              textAlign: TextAlign.end,
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: BrandColors.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            24.verticalSpace,
            Text(
              'Before you make this transfer',
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                color: BrandColors.containerColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: BrandColors.washedTextColor.withValues(alpha: .3),
                  width: .5.w,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: CustomIcon(icon: R.ASSETS_ICONS_CHECKBOX_SVG),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Text(
                          '''You should copy and use the text provided as narration and remarks for your transaction''',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: BrandColors.textColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: CustomIcon(icon: R.ASSETS_ICONS_CHECKBOX_SVG),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Text(
                          '''Transfer only the exact amount.\nDo not transfer an incorrect amount''',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: BrandColors.textColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: CustomIcon(icon: R.ASSETS_ICONS_CHECKBOX_SVG),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Text(
                          '''Do not save or reuse the account\nIt can only accept a single transfer''',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: BrandColors.textColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: CustomIcon(icon: R.ASSETS_ICONS_CHECKBOX_SVG),
                      ),
                      16.horizontalSpace,
                      Text(
                        '''This account expires in''',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: BrandColors.textColor,
                        ),
                      ),
                      8.horizontalSpace,
                      Consumer(
                        builder: (context, ref, child) {
                          final payable = ref.watch(accountPayable);
                          final remaining = ref.watch(
                            countdownProvider(payable!.expiryDate),
                          );

                          String formatDuration(Duration duration) {
                            final hours = duration.inHours
                                .remainder(24)
                                .toString()
                                .padLeft(2, '0');
                            final minutes = duration.inMinutes
                                .remainder(60)
                                .toString()
                                .padLeft(2, '0');
                            final seconds = duration.inSeconds
                                .remainder(60)
                                .toString()
                                .padLeft(2, '0');
                            return '$hours:$minutes:$seconds';
                          }

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              color: BrandColors.washedTextColor.withValues(
                                alpha: .3,
                              ),
                            ),
                            child: Text(
                              formatDuration(remaining),
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                color: BrandColors.textColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).padHorizontal,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: CustomIcon(
                    icon: R.ASSETS_ICONS_SECURED_BY_SVG,
                    width: 15.w,
                    height: 15.h,
                  ),
                ),
                TextSpan(text: '  Secured by '),
                TextSpan(
                  text: 'Guava',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    color: BrandColors.textColor,
                  ),
                ),
              ],
            ),
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: BrandColors.washedTextColor,
            ),
          ),
          16.verticalSpace,
          GestureDetector(
            onTap: () {
              setState(() {
                iAgree = !iAgree;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Durations.short1,
                  width: 18.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: iAgree ? BrandColors.primary : null,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: BrandColors.textColor,
                      width: 1.w,
                    ),
                  ),
                  child: iAgree
                      ? Icon(
                          Icons.check,
                          size: 12.sp,
                          color: BrandColors.backgroundColor,
                          weight: 5.w,
                        )
                      : null,
                ),
                6.horizontalSpace,
                Text(
                  'I understand these instructions',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    color: BrandColors.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          16.verticalSpace,
          CustomButton(
            onTap: () {
              ref.invalidate(balanceUsecaseProvider);
              ref.invalidate(myTransactionHistory);

              navkey.currentContext!.mixpanel.track(
                MixpanelEvents.depositCompleted,
              );

              context.toPath(pDashboard);
              context.notify.addNotification(
                NotificationTile(
                  content: 'Your wallet would be automatically credited.',
                ),
              );
            },
            title: 'I have made the payment',
            disable: !iAgree,
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
