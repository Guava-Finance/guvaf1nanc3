import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/features/transfer/presentation/widgets/transfer_type_selector.dart';

class TransferAppBar extends ConsumerWidget {
  const TransferAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferState = ref.watch(transferNotifierProvider);
    final notifier = ref.read(transferNotifierProvider.notifier);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: BrandColors.containerColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: SvgPicture.asset(R.ASSETS_ICONS_CLOSE_SVG),
            ),
          ),
        ),
        TransferTypeSelector(
          selected: transferState.selectedTransferType,
          onChanged: (value) {
            notifier.updateTransferType(value);
          },
        ),
        SvgPicture.asset(R.ASSETS_ICONS_SCAN_ICON_SVG)
      ],
    ).padHorizontal;
  }
}
