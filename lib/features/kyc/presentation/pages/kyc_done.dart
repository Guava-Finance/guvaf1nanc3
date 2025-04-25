import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/custom_button.dart';

class KycDonePage extends ConsumerStatefulWidget {
  const KycDonePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycDonePageState();
}

class _KycDonePageState extends ConsumerState<KycDonePage> with Loader {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC Verification'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          8.verticalSpace,
          40.verticalSpace,
          Icon(
            Icons.check_circle,
            size: 32.r,
            color: BrandColors.washedTextColor,
          ),
          12.verticalSpace,
          Text(
            '''Your data is being reviewed and you will get a\nnotification within 48 hours, thank you.''',
            style: context.textTheme.bodyMedium?.copyWith(
              color: BrandColors.washedTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          150.verticalSpace,
        ],
      ).padHorizontal,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onTap: () {
              context.go(pDashboard);
            },
            title: 'Okay',
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
