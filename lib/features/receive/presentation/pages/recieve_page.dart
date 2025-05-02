import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/features/receive/presentation/notifier/recieve.notifier.dart';
import 'package:guava/features/receive/presentation/pages/bank_recieve.dart';
import 'package:guava/features/receive/presentation/pages/scan_barcode.dart';
import 'package:guava/features/receive/presentation/widgets/recieve_type_selector.dart';

class RecievePage extends ConsumerWidget {
  const RecievePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recieveNotifierProvider.notifier);
    final tabState = ref.watch(activeReceiveTabState);

    return Scaffold(
      appBar: AppBar(
        title: RecieveTypeSelector(
          selected: tabState,
          onChanged: (value) {
            notifier.jumpTo(value);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: notifier.pageController,
                children: const [
                  ScanBarcode(),
                  BankRecieve(),
                ],
              ),
            ),
          ],
        ).padHorizontal,
      ),
    );
  }
}
