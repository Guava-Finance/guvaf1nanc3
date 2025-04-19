import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/services/solana.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/dashboard/presentation/pages/loader.dart';
import 'package:guava/features/onboarding/presentation/notifier/onboard.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';

class ImportRecoveryPhrase extends ConsumerStatefulWidget {
  const ImportRecoveryPhrase({super.key});

  @override
  ConsumerState<ImportRecoveryPhrase> createState() =>
      _ImportRecoveryPhraseState();
}

class _ImportRecoveryPhraseState extends ConsumerState<ImportRecoveryPhrase> {
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
    final on = ref.read(onboardingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Import Wallet'),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Text(
              'Help?',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
              ),
            ),
          ),
          16.horizontalSpace,
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            disable: controller.text.isEmpty ||
                !ref
                    .read(solanaServiceProvider)
                    .isMnemonicValid(controller.text),
            title: 'Import',
            onTap: () {
              context.nav.push(
                MaterialPageRoute(
                  builder: (_) => FullScreenLoader(
                    onLoading: () async {
                      await Future.delayed(Durations.long4);
                      await on.restoreAWallet(controller.text);
                      await Future.delayed(Durations.long4);
                    },
                    onSuccess: () {
                      // setup access code after restoring wallet
                      navkey.currentContext!.go(pSetupPin);
                    },
                    onError: () {
                      context.pop();
                    },
                    subMessages: [
                      'Initializing wallet restoration...',
                      'Generating secure wallet keys...',
                      'Encrypting private credentials...',
                      'Saving wallet securely to device...',
                      'Enabling gasless transaction support...',
                      'Verifying USDC token account...',
                      'Enabling USDC support if needed...',
                      'Finalizing wallet setup...',
                    ],
                    title: 'Please wait',
                  ),
                ),
              );
            },
          ),
          40.verticalSpace,
        ],
      ).padHorizontal,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.verticalSpace,
            Text(
              'Recovery phrase',
              style: context.textTheme.bodyLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: BrandColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Text(
              '''Restore an existing wallet with your 12\nor 24-word recovery phrase''',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: BrandColors.washedTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            30.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 12.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: BrandColors.washedTextColor,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    maxLines: 6,
                    controller: controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Recovery phrase',
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: BrandColors.washedTextColor,
                      ),
                      border: InputBorder.none,
                    ),
                    style: context.textTheme.bodyMedium,
                  ),
                  Divider(
                    color: BrandColors.washedTextColor.withValues(alpha: .3),
                  ),
                  8.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      Clipboard.getData('text/plain').then((e) {
                        if (e != null) {
                          controller.value = TextEditingValue(
                            text: e.text ?? '',
                          );
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Paste',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: BrandColors.washedTextColor,
                          ),
                        ),
                        8.horizontalSpace,
                        CustomIcon(
                          icon: R.ASSETS_ICONS_COPY_BUTTON_ICON_SVG,
                          width: 18.sp,
                          height: 18.sp,
                          color: BrandColors.washedTextColor,
                        ),
                      ],
                    ),
                  ),
                  8.verticalSpace,
                ],
              ),
            ),
          ],
        ).padHorizontal,
      ),
    );
  }
}
