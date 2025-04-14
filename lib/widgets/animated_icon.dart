import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:guava/widgets/app_icon.dart';

class AnimatedCustomIcon extends StatefulWidget {
  const AnimatedCustomIcon({
    required this.icon,
    this.width,
    this.height,
    this.movementIntensity = 2.0,
    this.movementSpeed = 0.5,
    super.key,
  });

  final String icon;
  final double? width;
  final double? height;
  final double movementIntensity;
  final double movementSpeed;

  @override
  State<AnimatedCustomIcon> createState() => _AnimatedCustomIconState();
}

class _AnimatedCustomIconState extends State<AnimatedCustomIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Random offsets to make each icon move in a slightly different pattern
  final double _randomXOffset = math.Random().nextDouble() * math.pi * 2;
  final double _randomYOffset = math.Random().nextDouble() * math.pi * 2;

  @override
  void initState() {
    super.initState();

    // Create a continuous animation
    _controller = AnimationController(
      duration: Duration(seconds: (2 / widget.movementSpeed).round()),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);

    // Make the animation repeat indefinitely
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calculate subtle movement based on sine waves
        final double dx = math.sin(_animation.value + _randomXOffset) *
            widget.movementIntensity;
        final double dy = math.cos(_animation.value + _randomYOffset) *
            widget.movementIntensity;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: child,
        );
      },
      child: CustomIcon(
        icon: widget.icon,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
