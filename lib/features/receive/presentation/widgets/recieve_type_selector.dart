import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/receive/presentation/widgets/recieve_option.dart';

class RecieveTypeSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const RecieveTypeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.short1,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: BrandColors.containerColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RecieveOption(
            onChanged: () => onChanged(0),
            selected: selected == 0,
            value: 'Wallet',
          ),
          4.horizontalSpace,
          RecieveOption(
            onChanged: () => onChanged(1),
            selected: selected == 1,
            value: 'Bank',
          )
        ],
      ),
    );
  }
}
