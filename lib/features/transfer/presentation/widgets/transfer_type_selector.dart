import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/build_option.dart';

class TransferTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const TransferTypeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // todo: chnage to ios Segemented controller
    return AnimatedContainer(
      duration: Durations.extralong1,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: BrandColors.containerColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BuildOption(
            onChanged: onChanged,
            selected: selected,
            value: 'Wallet',
          ),
          4.horizontalSpace,
          BuildOption(
            onChanged: onChanged,
            selected: selected,
            value: 'Bank',
          )
        ],
      ),
    );
  }
}
