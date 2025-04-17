import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/extensions/widget.dart';
import 'package:guava/core/styles/colors.dart';

class FullScreenLoader extends StatefulWidget {
  const FullScreenLoader({
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    required this.subMessages,
    required this.title,
    super.key,
  });

  final Future<void> Function()? onLoading;
  final VoidCallback onSuccess;
  final VoidCallback? onError;
  final List<String> subMessages;
  final String title;

  @override
  State<FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<FullScreenLoader> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5.w,
                  color: BrandColors.textColor,
                ),
              ),
              24.verticalSpace,
              Text(
                widget.title,
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              24.verticalSpace,
            ],
          ),
          Positioned(
            bottom: context.mediaQuery.size.height * 0.4,
            left: 30.w,
            right: 30.w,
            child: AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                ...widget.subMessages.map(
                  (e) => RotateAnimatedText(e),
                )
              ],
              onTap: () {},
            ),
          ),
        ],
      ).padHorizontal,
    );
  }

  void _init() async {
    try {
      await widget.onLoading?.call();
      widget.onSuccess.call();
    } catch (e) {
      widget.onError?.call();
      return;
    }
  }
}
