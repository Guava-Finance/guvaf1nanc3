import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/resources/mixins/loading.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/features/transfer/presentation/notifier/transfer.notifier.dart';
import 'package:guava/widgets/custom_button.dart';
import 'package:guava/widgets/custom_textfield.dart';

class AddToAddressBook extends ConsumerStatefulWidget {
  const AddToAddressBook({
    this.onSaved,
    super.key,
  });

  final Function(bool)? onSaved;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddToAddressBookState();
}

class _AddToAddressBookState extends ConsumerState<AddToAddressBook>
    with Loader {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          24.verticalSpace,
          CustomTextfield(
            controller: controller,
            hintText: 'Enter address label',
            onChanged: (p0) {
              if (p0 != null) {
                ref.read(addressLabel.notifier).state = p0;
              }
            },
          ),
          30.verticalSpace,
          ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, data, __) {
                return CustomButton(
                  onTap: () async {
                    await withLoading(() async {
                      final result = await ref
                          .read(transferNotifierProvider)
                          .saveToAddressBook();

                      widget.onSaved?.call(result);
                      navkey.currentContext!.pop();
                    });
                  },
                  title: 'Save Address',
                  isLoading: data,
                );
              }),
          context.mediaQuery.viewInsets.bottom.verticalSpace,
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
