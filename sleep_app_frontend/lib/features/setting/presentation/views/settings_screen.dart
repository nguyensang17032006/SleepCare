import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme.dart';
import 'edit_profile_screen.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/logout_vm.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _osFocusEnabled = true;
  bool _sleepPrepEnabled = true;
  bool _losslessEnabled = false;
  int _snoozeInterval = 15;

  @override
  Widget build(BuildContext context) {
    final logoutVM = context.watch<LogoutViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SETTINGS',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sleep Hygiene',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardLightColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'John Doe',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'johndoe@example.com',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppTheme.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Automation',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                Icons.do_not_disturb_on_total_silence,
                'Autocall in OS Focus',
                'Mutes all notifications when active',
                _osFocusEnabled,
                (val) {
                  setState(() => _osFocusEnabled = val);
                },
              ),
              const SizedBox(height: 12),
              _buildTile(
                Icons.music_note,
                'Music Playback',
                'Duration',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '45m',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Reminders',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                Icons.nights_stay,
                'Sleep Prep Reminder',
                'Reminds at 10:30 PM (30 min \nbefore sleep)',
                _sleepPrepEnabled,
                (val) {
                  setState(() => _sleepPrepEnabled = val);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Snooze Intervals',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIntervalChip(10),
                  _buildIntervalChip(15),
                  _buildIntervalChip(20),
                  _buildIntervalChip(30),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                'Audio Fidelity',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                Icons.speaker,
                'Lossless Playback',
                'Higher battery usage',
                _losslessEnabled,
                (val) {
                  setState(() => _losslessEnabled = val);
                },
              ),
              const SizedBox(height: 30),
              logoutVM.isLoading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: 'Đăng xuất',
                      onPressed: () async {
                        // Hiển thị popup xác nhận và chờ người dùng chọn
                        final isLogout = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Đăng xuất'),
                              content: const Text(
                                'Bạn có chắc chắn muốn đăng xuất khỏi SleepCare không?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pop(false), // Chọn Không -> trả về false
                                  child: const Text(
                                    'Không',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pop(true), // Chọn Có -> trả về true
                                  child: const Text(
                                    'Đăng xuất',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        // Nếu người dùng chọn "Đăng xuất" (true), tiến hành xử lý logic
                        if (isLogout == true) {
                          await logoutVM.handleLogout();
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return _buildTile(
      icon,
      title,
      subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.primaryColor,
        inactiveThumbColor: AppTheme.textMuted,
        inactiveTrackColor: AppTheme.textMuted.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildIntervalChip(int mins) {
    bool isSelected = _snoozeInterval == mins;
    return GestureDetector(
      onTap: () => setState(() => _snoozeInterval = mins),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.cardLightColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${mins}m',
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
