import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/register/register_screen.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      },
      child: Text(
        AppLocalizations.of(context)!.loginCreateAccount,
        style: const TextStyle(
          color: AppTheme.textLight,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
