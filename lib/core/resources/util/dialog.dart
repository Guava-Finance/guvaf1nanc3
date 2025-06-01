import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/routes/router.dart';
import 'package:guava/core/styles/colors.dart';

final customDialogProvider = Provider<CustomDialog>((ref) => CustomDialog());

class CustomDialog {
  bool isOkayClicked = false;

  Future<void> openDialog({
    required String title,
    required String content,
    bool isDimssible = true,
    String? action,
    VoidCallback? onTap,
  }) async {
    final context = navkey.currentContext!;

    showDialog(
      context: context,
      barrierDismissible: isDimssible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          content,
          style: context.textTheme.bodyMedium?.copyWith(
            color: BrandColors.backgroundColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              isOkayClicked = true;
              context.nav.pop();

              onTap?.call();
            },
            child: Text(action ?? 'OK'),
          ),
        ],
      ),
    ).then((v) {
      if (!isOkayClicked) {
        onTap?.call();
      }
    });
  }
}
