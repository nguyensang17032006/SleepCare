import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/app/widget/custom_text_field.dart';
import '../../../core/app/widget/primary_button.dart';
import '../../home/presentation/widget/glass_card.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Security & Privacy',
          style: TextStyle(color: AppTheme.textLight, fontSize: 16),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Password',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Secure your account with a new password.',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 40),

              const CustomTextField(
                label: 'CURRENT PASSWORD',
                hint: '••••••••',
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'NEW PASSWORD',
                hint: '••••••••',
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'CONFIRM NEW PASSWORD',
                hint: '••••••••',
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 30),

              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.shield_outlined,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Security Requirements',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRequirementRow(
                      Icons.check_circle,
                      'At least 8 characters long',
                      true,
                    ),
                    const SizedBox(height: 8),
                    _buildRequirementRow(
                      Icons.brightness_1_outlined,
                      'Must include a number or special character',
                      false,
                    ),
                    const SizedBox(height: 8),
                    _buildRequirementRow(
                      Icons.brightness_1_outlined,
                      'Must not be a previously used password',
                      false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              PrimaryButton(
                text: 'Update Password',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot your current password?',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementRow(IconData icon, String text, bool isMet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: isMet ? Colors.greenAccent : AppTheme.textMuted,
          size: 14,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.greenAccent : AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
