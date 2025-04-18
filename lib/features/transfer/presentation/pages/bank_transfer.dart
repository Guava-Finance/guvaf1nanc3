import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/presentation/pages/sub/bank_tab_view.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';

class BankTransfer extends StatefulWidget {
  const BankTransfer({super.key});

  @override
  State<BankTransfer> createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> with TickerProviderStateMixin {
  late final TextEditingController controller;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    controller = TextEditingController();

    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextfield(
          hintText: 'Select Country',
          controller: controller,
          suffixIcon: SvgPicture.asset(R.ASSETS_ICONS_ARROW_FORWARD_SVG),
        ).padHorizontal,
        10.verticalSpace,
        CustomTextfield(
          hintText: 'Select Bank',
          controller: controller,
          suffixIcon: SvgPicture.asset(R.ASSETS_ICONS_ARROW_FORWARD_SVG),
        ).padHorizontal,
        10.verticalSpace,
        CustomTextfield(
          hintText: 'Enter 10 digit account number',
          controller: controller,
        ).padHorizontal,
        10.verticalSpace,
        CustomTextfield(
          hintText: 'Enter amount',
          controller: controller,
        ).padHorizontal,
        10.verticalSpace,
        CustomTextfield(
          hintText: 'Purpose of transaction',
          controller: controller,
          suffixIcon: SvgPicture.asset(R.ASSETS_ICONS_ADD_CIRCLE_SVG),
        ).padHorizontal,
        20.verticalSpace,
        CustomButton(
          onTap: () => context.push(pEnterAmountBank),
          title: 'Continue',
        ).padHorizontal,
        10.verticalSpace,
        Expanded(
          child: BankTabBarView(
            tabController: _tabController,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
