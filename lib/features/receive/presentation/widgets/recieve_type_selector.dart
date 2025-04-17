import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/receive/presentation/widgets/recieve_option.dart';

class RecieveTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const RecieveTypeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: BrandColors.containerColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RecieveOption(
            onChanged: onChanged,
            selected: selected,
            value: 'Code',
          ),
          4.horizontalSpace,
          RecieveOption(
            onChanged: onChanged,
            selected: selected,
            value: 'Bank',
          )
        ],
      ),
    );
  }
}
