import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/logout_vm.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/profile_vm.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/schedule_vm.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';
import 'package:sleep_app_frontend/main.dart';

import 'edit_profile_screen.dart';
import 'security_screen.dart';
import 'sleep_schedule_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String _userId = supabaseClient.auth.currentUser?.id ?? '';

  bool _sleepPreparationEnabled = true;

  late final ScheduleViewModel _scheduleVM;

  @override
  void initState() {
    super.initState();

    _scheduleVM = ScheduleViewModel();
    _scheduleVM.addListener(_onScheduleChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_userId.isNotEmpty) {
        await context.read<ProfileViewModel>().loadProfile(_userId);
      }

      await _scheduleVM.loadSchedule();
    });
  }

  void _onScheduleChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _scheduleVM.removeListener(_onScheduleChanged);
    _scheduleVM.dispose();
    super.dispose();
  }

  Future<void> _openSleepSchedule() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SleepScheduleScreen()),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    if (!mounted || _userId.isEmpty) return;

    await context.read<ProfileViewModel>().loadProfile(_userId);
  }

  void _openSecurity() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SecurityScreen()),
    );
  }

  Future<void> _handleLogout() async {
    final logoutVM = context.read<LogoutViewModel>();
    final l10n = AppLocalizations.of(context)!;

    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.settingsLogout,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            l10n.settingsLogoutConfirm,
            style: const TextStyle(color: AppTheme.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                l10n.settingsNo,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                l10n.settingsYes,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (accepted != true) return;

    await logoutVM.handleLogout();
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    final logoutVM = context.watch<LogoutViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
            children: [
              const Text(
                'Cài đặt',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Điều chỉnh trải nghiệm SleepCare phù hợp với thói quen ngủ của bạn.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              _buildProfileCard(profileVM),

              const SizedBox(height: 28),

              _sectionTitle('GIẤC NGỦ'),

              const SizedBox(height: 12),

              _buildSettingGroup(
                children: [
                  _settingItem(
                    icon: Icons.bedtime_outlined,
                    title: 'Lịch ngủ',
                    subtitle: 'Giờ đi ngủ, ngày áp dụng và nhắc nhở',
                    onTap: _openSleepSchedule,
                  ),

                  _divider(),

                  _switchSettingItem(
                    icon: Icons.nights_stay_outlined,
                    title: 'Chuẩn bị đi ngủ',
                    subtitle:
                        'Nhắc bạn giảm hoạt động và thư giãn trước giờ ngủ',
                    value: _sleepPreparationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _sleepPreparationEnabled = value;
                      });
                    },
                  ),

                  _divider(),

                  _settingItem(
                    icon: Icons.snooze_rounded,
                    title: 'Báo lại',
                    subtitle: 'Nhắc lại sau ${_scheduleVM.snoozeMinutes} phút',
                    trailing: _valueChip('${_scheduleVM.snoozeMinutes} phút'),
                    onTap: _showSnoozeOptions,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _sectionTitle('TÀI KHOẢN & BẢO MẬT'),

              const SizedBox(height: 12),

              _buildSettingGroup(
                children: [
                  _settingItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Bảo mật & mật khẩu',
                    subtitle: 'Thay đổi mật khẩu và bảo vệ tài khoản',
                    onTap: _openSecurity,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: logoutVM.isLoading ? null : _handleLogout,
                  icon: logoutVM.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                        ),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.redAccent.withValues(alpha: 0.45),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProfileViewModel profileVM) {
    final user = profileVM.user;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: _openProfile,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.cardLightColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: profileVM.isLoading
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 100, child: LinearProgressIndicator()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName.isNotEmpty == true
                              ? user!.fullName
                              : 'Tài khoản SleepCare',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),

            const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.3,
      ),
    );
  }

  Widget _buildSettingGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            _iconBox(icon),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textMuted,
                ),
          ],
        ),
      ),
    );
  }

  Widget _switchSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _iconBox(icon),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeThumbColor: AppTheme.primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: AppTheme.primaryColor, size: 21),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withValues(alpha: 0.055),
      ),
    );
  }

  Widget _valueChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _showSnoozeOptions() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thời gian báo lại',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Nếu bỏ qua lời nhắc chuẩn bị ngủ, SleepCare sẽ nhắc lại sau:',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [10, 15, 20, 30].map((minutes) {
                    final selected = minutes == _scheduleVM.snoozeMinutes;

                    return ChoiceChip(
                      selected: selected,
                      label: Text('$minutes phút'),
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: AppTheme.cardLightColor,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppTheme.textMuted,
                      ),
                      onSelected: (_) {
                        Navigator.pop(context, minutes);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    final success = await _scheduleVM.updateSnoozeMinutes(result);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lưu thời gian báo lại.')),
      );
    }
  }
}
