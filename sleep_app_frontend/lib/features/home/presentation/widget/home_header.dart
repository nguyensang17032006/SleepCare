import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sleep Care',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDFBBE4),
          ),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: Icon(Icons.bed, color: Colors.white),
        ),
      ],
    );
  }
}
