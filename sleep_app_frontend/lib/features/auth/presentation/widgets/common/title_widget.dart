import "package:flutter/material.dart";

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/logo_sleep.png', width: 45, height: 45),

        const SizedBox(width: 10),

        const Text(
          "SleepCare",
          style: TextStyle(
            color: Color.fromARGB(255, 243, 207, 248),
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
