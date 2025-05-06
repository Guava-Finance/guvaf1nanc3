import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/page_indicator.dart';

class MnenomicsInstructionsPage extends ConsumerStatefulWidget {
  const MnenomicsInstructionsPage({
    this.isBackUp = false,
    super.key,
  });

  final bool isBackUp;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MnenomicsInstructionsPageState();
}

class _MnenomicsInstructionsPageState
    extends ConsumerState<MnenomicsInstructionsPage> {
  bool _understandLoseMyPhrase = false;
  bool _understandRevealMyPhrase = false;
  bool _understandSafety = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageIndicator(
          totalPages: 4,
          currentPage: 0,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.isBackUp ? 'Backup recovery phrase' : 'Show recovry phrase',
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Text(
            '''Your 12 key-phrase is the only way to recover your\nfunds if you lose access to your wallet.''',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.washedTextColor,
              fontSize: 12.sp,
            ),
          ),
          60.verticalSpace,
          CustomIcon(
            icon: R.ASSETS_ICONS_LOCK_WITH_FLOATER_SVG,
            width: 272.2,
            height: 263.h,
          ),
          60.verticalSpace,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _understandLoseMyPhrase = !_understandLoseMyPhrase;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _understandLoseMyPhrase
                            ? BrandColors.primary
                            : BrandColors.washedTextColor,
                      ),
                      padding: EdgeInsets.all(3.sp),
                      child: _understandLoseMyPhrase
                          ? Icon(
                              Icons.check,
                              size: 12.sp,
                              color: BrandColors.backgroundColor,
                            )
                          : null,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        '''If i lose my key phrase, i will not be able to access my funds again''',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              16.verticalSpace,
              GestureDetector(
                onTap: () {
                  setState(() {
                    _understandRevealMyPhrase = !_understandRevealMyPhrase;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _understandRevealMyPhrase
                            ? BrandColors.primary
                            : BrandColors.washedTextColor,
                      ),
                      padding: EdgeInsets.all(3.sp),
                      child: _understandRevealMyPhrase
                          ? Icon(
                              Icons.check,
                              size: 12.sp,
                              color: BrandColors.backgroundColor,
                            )
                          : null,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        '''If i reveal or share my key phrase my funds could be stolen''',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              16.verticalSpace,
              GestureDetector(
                onTap: () {
                  setState(() {
                    _understandSafety = !_understandSafety;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _understandSafety
                            ? BrandColors.primary
                            : BrandColors.washedTextColor,
                      ),
                      padding: EdgeInsets.all(3.sp),
                      child: _understandSafety
                          ? Icon(
                              Icons.check,
                              size: 12.sp,
                              color: BrandColors.backgroundColor,
                            )
                          : null,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        '''I am fully responsible for the safety of my key phrase''',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ).padHorizontal,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onTap: () {
              context.push(pAccessPin).then((v) {
                if ((v != null) && (v as bool)) {
                  navkey.currentContext!.push(
                    pMnenomicShow,
                    extra: widget.isBackUp,
                  );
                }
              });
            },
            title: 'Confirm',
            disable: !(_understandLoseMyPhrase &&
                _understandRevealMyPhrase &&
                _understandSafety),
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
