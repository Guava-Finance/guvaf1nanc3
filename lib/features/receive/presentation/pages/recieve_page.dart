import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/features/receive/presentation/notifier/recieve.notifier.dart';
import 'package:guava/features/receive/presentation/pages/bank_recieve.dart';
import 'package:guava/features/receive/presentation/pages/scan_barcode.dart';
import 'package:guava/features/receive/presentation/widgets/recieve_type_selector.dart';
import 'package:guava/widgets/back_wrapper.dart';

class RecievePage extends ConsumerWidget {
  const RecievePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recieveState = ref.watch(recieveNotifierProvider);
    final notifier = ref.read(recieveNotifierProvider.notifier);

    return BackWrapper(
      title: 'Recieve',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          Center(
            child: RecieveTypeSelector(
              selected: recieveState.selectedRecieveType,
              onChanged: (value) {
                notifier.updateRecieveType(value);
              },
            ),
          ),
          15.verticalSpace,
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: notifier.pageController,
              children: const [
                ScanBarcode(),
                BankRecieve()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
