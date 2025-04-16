import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/app_strings.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/dashboard/presentation/pages/loader.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';

class ImportRecoveryPhrase extends StatefulWidget {
  const ImportRecoveryPhrase({super.key});

  @override
  State<ImportRecoveryPhrase> createState() => _ImportRecoveryPhraseState();
}

class _ImportRecoveryPhraseState extends State<ImportRecoveryPhrase> {
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
            disable: controller.text.isEmpty,
            title: 'Import',
            onTap: () {
              context.nav.push(
                MaterialPageRoute(
                  builder: (_) => FullScreenLoader(
                    onLoading: () async {
                      await Future.delayed(Duration(seconds: 3));
                    },
                    onSuccess: () {
                      context.push(Strings.dashboard);
                    },
                    onError: () {
                      context.pop();
                    },
                    subMessages: [
                      'Generating secret phrase',
                      'Creating SPL token accounts',
                      'This may take a few minutes',
                    ],
                    title: 'Creating your wallet',
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
