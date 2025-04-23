import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/resources/util/debouncer.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/home/presentation/notifier/home.notifier.dart';
import 'package:guava/widgets/app_icon.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';

class SetUsername extends ConsumerStatefulWidget {
  const SetUsername({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetUsernameState();
}

class _SetUsernameState extends ConsumerState<SetUsername> with Loader {
  final debounce = Debouncer(duration: Durations.extralong4);

  late final TextEditingController usernameCtrl;

  @override
  void initState() {
    usernameCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isUsernameAvailableProvider.notifier).state = null;
    });

    super.initState();
  }

  @override
  void dispose() {
    usernameCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hn = ref.read(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Username'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your unique name for your account',
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.washedTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          CustomTextfield(
            hintText: '',
            controller: usernameCtrl,
            label: 'Username',
            preffixIcon: Text(
              '@',
              style: context.textTheme.bodyMedium?.copyWith(
                color: BrandColors.washedTextColor,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                usernameCtrl.clear();
                HapticFeedback.lightImpact();
              },
              child: CircleAvatar(
                maxRadius: 10.r,
                backgroundColor: BrandColors.washedTextColor.withValues(
                  alpha: .1,
                ),
                child: Padding(
                  padding: EdgeInsets.all(7.0.sp),
                  child: CustomIcon(icon: R.ASSETS_ICONS_CLOSE_SVG),
                ),
              ),
            ),
            onChanged: (p0) {
              ref.read(isUsernameAvailableProvider.notifier).state = null;

              debounce.run(() async {
                if ((p0 ?? '').isNotEmpty) {
                  withLoading(() async {
                    await hn.checkUsername(p0 ?? '');
                  });
                }
              });
            },
          ),
          8.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              final usernameAvailable = ref.watch(isUsernameAvailableProvider);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (usernameAvailable != null && !usernameAvailable) ...{
                    Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 8.r,
                          backgroundColor: BrandColors.red,
                          child: Padding(
                            padding: EdgeInsets.all(4.5.sp),
                            child: CustomIcon(
                              icon: R.ASSETS_ICONS_CLOSE_SVG,
                              color: BrandColors.backgroundColor,
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          'Username must be between 2 and 20 characters long',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: BrandColors.red,
                          ),
                        )
                      ],
                    ),
                  },
                  if (usernameAvailable != null && usernameAvailable) ...{
                    Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 8.r,
                          backgroundColor: BrandColors.lightGreen,
                          child: Padding(
                            padding: EdgeInsets.all(4.5.sp),
                            child: Icon(Icons.check, size: 7.sp, weight: 4),
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          'Username available',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: BrandColors.lightGreen,
                          ),
                        )
                      ],
                    ),
                  },
                ],
              );
            },
          )
        ],
      ).padHorizontal,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final usernameAvailable = ref.watch(isUsernameAvailableProvider);

              return ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) => CustomButton(
                  onTap: () async {
                    await withLoading(() async {
                      await hn.setUsername(usernameCtrl.text).then((v) {
                        if (v) navkey.currentContext!.pop();
                      });
                    });
                  },
                  title: 'Done',
                  disable: (usernameAvailable == null || !usernameAvailable),
                  isLoading: value,
                ),
              );
            },
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
