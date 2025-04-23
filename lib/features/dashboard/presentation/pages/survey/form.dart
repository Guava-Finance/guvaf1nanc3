import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/analytics/mixpanel/const.dart';
import 'package:guava/core/resources/analytics/mixpanel/mix.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/features/dashboard/presentation/widgets/survey/tile.dart';

class GuavafiSurvey extends ConsumerStatefulWidget {
  const GuavafiSurvey({super.key});

  @override
  ConsumerState<GuavafiSurvey> createState() => _GuavafiSurveyState();
}

class _GuavafiSurveyState extends ConsumerState<GuavafiSurvey> {
  @override
  Widget build(BuildContext context) {
    final mixpanel = ref.read(mixpanelProvider);

    // todo: implement global text style once available
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            24.verticalSpace,
            Text(
              'What new features do you want to see in Guavafi?',
              style: context.textTheme.headlineLarge,
            ),
            24.verticalSpace,
            Wrap(
              spacing: 5.w,
              runSpacing: 5.h,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                // todo: fetch survey list from system
                SurveyTile(
                  title: 'Spend n Save',
                  description:
                      '''Save a certain percentage as you spend your money''',
                  isActive: true,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    mixpanel.track(
                      MixPanelKeys.featureSurvey,
                      properties: {
                        'feature': 'spend_n_save',
                        'country': '',
                      },
                    );
                  },
                ),
                SurveyTile(
                  title: 'Loans',
                  description: '''Get loans from our global partners''',
                ),
                SurveyTile(
                  title: 'Increase spend limits',
                  description: '''Request for more spending limit''',
                  isActive: true,
                ),
                SurveyTile(
                  title: 'Staking',
                  description: '''Lock up certain token and get interest''',
                ),
              ],
            )
          ],
        ).padHorizontal,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // todo: change to primary button component
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 24.w,
            ),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Center(
              child: Text(
                'Submit',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          12.verticalSpace,
        ],
      ).pad,
    );
  }
}
