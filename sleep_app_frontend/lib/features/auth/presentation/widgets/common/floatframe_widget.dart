import "package:flutter/material.dart";
import 'dart:ui';

class FloatFrameWidget extends StatelessWidget {
  final Widget child;
  const FloatFrameWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFF041C32).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
