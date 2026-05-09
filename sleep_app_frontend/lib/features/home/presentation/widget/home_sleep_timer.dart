import 'package:flutter/material.dart';

class SleepTimer extends StatelessWidget {
  final Size size;

  const SleepTimer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: 387,
      child: const Text(
        'Sleep Timer',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFDFBBE4),
        ),
      ),
    );
  }
}
