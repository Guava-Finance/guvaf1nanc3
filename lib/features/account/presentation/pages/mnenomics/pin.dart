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
import 'package:guava/features/onboarding/presentation/widgets/number_pad.dart';
import 'package:guava/widgets/page_indicator.dart';
import 'package:pinput/pinput.dart';

class MnenomicsEnterPinPage extends ConsumerStatefulWidget {
  const MnenomicsEnterPinPage({
    this.isBackUp = false,
    super.key,
  });

  final bool isBackUp;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MnenomicsEnterPinPageState();
}

class _MnenomicsEnterPinPageState extends ConsumerState<MnenomicsEnterPinPage> {
  late final TextEditingController pinCtrl;
  String? _warningMessage;

  @override
  void initState() {
    pinCtrl = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    pinCtrl.dispose();

    super.dispose();
  }

  // Show a warning dialog when attempts are low
  void _showWarningDialog(int attemptsRemaining) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Warning'),
        content: Text(
          '''Incorrect PIN. You have $attemptsRemaining ${attemptsRemaining == 1 ? 'attempt' : 'attempts'} '''
          '''remaining before all wallet data is wiped.''',
          style: context.textTheme.bodyMedium?.copyWith(
            color: BrandColors.backgroundColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('I Understand'),
          ),
        ],
      ),
    );
  }

  bool isOkayClicked = false;

  // Show a wiped data dialog
  void _showWipedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Security Alert'),
        content: Text(
          '''Maximum PIN attempts exceeded. All wallet data has been wiped for security reasons.''',
          style: context.textTheme.bodyMedium?.copyWith(
            color: BrandColors.backgroundColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              isOkayClicked = true;

              context.pop();
              navkey.currentContext!.go(pOnboarding);
            },
            child: Text('OK'),
          ),
        ],
      ),
    ).then((v) {
      if (!isOkayClicked) {
        navkey.currentContext!.go(pOnboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: PageIndicator(
            totalPages: 4,
            currentPage: 1,
          ),
        ),
        body: Column(children: [
          24.verticalSpace,
          Text(
            'Enter up your PIN',
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: BrandColors.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          Text(
            'Insert PIN',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: BrandColors.washedTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (_warningMessage != null) ...[
            12.verticalSpace,
            Text(
              _warningMessage!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          48.verticalSpace,
          Pinput(
            controller: pinCtrl,
            length: 6,
            readOnly: true,
            pinAnimationType: PinAnimationType.scale,
            obscuringWidget: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BrandColors.primary,
              ),
            ),
            showCursor: false,
            obscureText: true,
            defaultPinTheme: PinTheme(
              textStyle: context.textTheme.headlineLarge,
              height: 20.h,
              width: 20.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BrandColors.darkD9,
              ),
            ),
            onCompleted: (value) async {
              final accountNotifier = ref.watch(accountNotifierProvider);
              final result = await accountNotifier.validatePin(value);

              switch (result.status) {
                case PinValidationStatus.correct:
                  setState(() => _warningMessage = null);
                  navkey.currentContext!.pop(true);
                  break;

                case PinValidationStatus.incorrect:
                  pinCtrl.clear();
                  final attemptsRemaining = result.attemptsRemaining!;

                  if (attemptsRemaining <= WARNING_THRESHOLD) {
                    setState(() {
                      _warningMessage =
                          'Warning: $attemptsRemaining ${attemptsRemaining == 1 ? 'attempt' : 'attempts'} remaining';
                    });
                    _showWarningDialog(attemptsRemaining);
                  } else {
                    setState(() => _warningMessage = null);
                    navkey.currentContext!.notify.addNotification(
                      NotificationTile(
                        content: 'Incorrect PIN',
                        notificationType: NotificationType.error,
                      ),
                    );
                  }
                  break;

                case PinValidationStatus.wiped:
                  pinCtrl.clear();
                  _showWipedDialog();
                  break;
              }
            },
          ),
          24.verticalSpace,
          Spacer(),
          CustomNumberPad(
            controller: pinCtrl,
          ),
          40.verticalSpace,
        ]).padHorizontal,
      ),
    );
  }
}
