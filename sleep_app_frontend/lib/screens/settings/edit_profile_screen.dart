import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'security_screen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: AppTheme.textLight, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, color: Colors.white, size: 40),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle, border: Border.all(color: AppTheme.bgColor, width: 2)),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('MALE, 28 YRS', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                    const Text('Premium Member', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              const CustomTextField(label: 'Full Name', hint: 'Alex Moore', prefixIcon: Icons.person_outline),
              const SizedBox(height: 20),
              const CustomTextField(label: 'Email Address', hint: 'alex.m@example.com', prefixIcon: Icons.email_outlined),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('GENDER', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(color: AppTheme.cardLightColor, borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.male, color: AppTheme.textMuted, size: 20),
                              Text('Male', style: TextStyle(color: Colors.white)),
                              Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BIRTH DATE', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(color: AppTheme.cardLightColor, borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.calendar_today, color: AppTheme.textMuted, size: 16),
                              Text('12 May 1995', style: TextStyle(color: Colors.white, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              const Text('Sleep Settings', style: TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              _buildSettingCard(Icons.nights_stay, 'Sleep Goal', '8.0 hours', 'TARGET'),
              const SizedBox(height: 12),
              _buildSettingCard(Icons.wb_sunny, 'Chronotype', 'Early Bird', ''),
              const SizedBox(height: 40),
              
              const Text('Security', style: TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardLightColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.lock_outline, color: AppTheme.textLight, size: 20),
                      SizedBox(width: 8),
                      Text('Change Password', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              PrimaryButton(text: 'Save Changes', onPressed: () => Navigator.pop(context)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(IconData icon, String title, String value, String badge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.0)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (badge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Text(badge, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
