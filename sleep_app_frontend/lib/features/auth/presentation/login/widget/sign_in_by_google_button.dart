import 'package:flutter/material.dart';

class SignInByGoogleButton extends StatelessWidget {
  const SignInByGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          'assets/images/google.png',
          width: 20,
          height: 20,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.g_mobiledata, color: Colors.white),
        ),
        label: const Text(
          'Sign in with Google',
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
