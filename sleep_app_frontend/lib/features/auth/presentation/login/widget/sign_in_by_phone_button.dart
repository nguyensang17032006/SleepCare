import 'package:flutter/material.dart';

class SignInByPhoneButton extends StatelessWidget {
  const SignInByPhoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.phone, color: Colors.white, size: 20),
        label: const Text(
          'Sign in with phone number',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
