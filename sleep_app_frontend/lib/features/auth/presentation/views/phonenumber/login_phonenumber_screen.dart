import "package:flutter/material.dart";
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'widget/countrypicker.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'confirm_phonenumber.dart';

class LoginPhoneNumberScreen extends StatelessWidget {
  const LoginPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textMuted),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Login with phone number',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Enter your phone number',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 10),

            Text(
              'We will send you a verification code to verify your account.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 40),
            CountryPicker(),
            SizedBox(height: 40),
            PrimaryButton(text: 'Send verification code', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmPhoneNumberScreen()));
            }),
          ],
        ),
      ),
    );
  }
}
