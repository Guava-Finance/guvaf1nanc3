import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/widgets/transfer_option.dart';

class TransferTypeSelector extends StatefulWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const TransferTypeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  @override
  State<TransferTypeSelector> createState() => _TransferTypeSelectorState();
}

class _TransferTypeSelectorState extends State<TransferTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.short1,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: BrandColors.containerColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          // This is the sliding highlight
          AnimatedPositioned(
            duration: Durations.medium2,
            curve: Curves.linear,
            left: widget.selected == 0 ? 0 : null,
            right: widget.selected == 1 ? 0 : null,
            top: 0,
            bottom: 0,
            width: _calculateSegmentWidth(context) / 2,
            child: Container(
              decoration: BoxDecoration(
                color: BrandColors.containerColor,
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
          // This is the actual segmented control
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => widget.onChanged(0),
                child: TransferOption(
                  selected: widget.selected == 0,
                  value: 'Wallet',
                ),
              ),
              4.horizontalSpace,
              GestureDetector(
                onTap: () => widget.onChanged(1),
                child: TransferOption(
                  selected: widget.selected == 1,
                  value: 'Bank',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to calculate the width for the sliding indicator
  double _calculateSegmentWidth(BuildContext context) {
    // This is an estimate - for more precise measurements you might want to use
    // LayoutBuilder or GlobalKey to measure the actual width
    return (MediaQuery.of(context).size.width - 16.w) / 2;
  }
}
