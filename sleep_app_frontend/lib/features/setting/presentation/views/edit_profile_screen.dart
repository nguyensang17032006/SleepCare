import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sleep_app_frontend/l10n/app_localizations.dart';
import 'package:sleep_app_frontend/main.dart';

import '../../../../core/app/widget/custom_text_field.dart';
import '../../../../core/theme/theme.dart';
import '../viewmodels/profile_vm.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isEditing = false;

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;

  final String _userId =
      supabaseClient.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    if (_userId.isEmpty) return;

    final profileVM =
        context.read<ProfileViewModel>();

    await profileVM.loadProfile(_userId);

    if (!mounted) return;

    final user = profileVM.user;

    if (user == null) return;

    _nameController.text = user.fullName;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber;

    _selectedGender =
        user.sex.isEmpty ? null : user.sex;

    if (user.dateOfBirth.isNotEmpty) {
      _selectedDate =
          DateTime.tryParse(user.dateOfBirth);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    if (!_isEditing) return;

    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              surface: AppTheme.cardColor,
              onSurface: AppTheme.textLight,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _handleSaveChanges() async {
    if (_userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không tìm thấy người dùng hiện tại',
          ),
        ),
      );

      return;
    }

    final viewModel =
        context.read<ProfileViewModel>();

    final success =
        await viewModel.updateProfile(
      id: _userId,
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      sex: _selectedGender ?? '',
      dateOfBirth: _selectedDate != null
          ? _selectedDate!
              .toIso8601String()
              .split('T')
              .first
          : '',
      phoneNumber:
          _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .profileUpdateSuccess,
          ),
        ),
      );
    }
  }

  void _cancelEditing() {
    final user =
        context.read<ProfileViewModel>().user;

    if (user != null) {
      _nameController.text = user.fullName;
      _emailController.text = user.email;
      _phoneController.text =
          user.phoneNumber;

      _selectedGender =
          user.sex.isEmpty ? null : user.sex;

      _selectedDate =
          user.dateOfBirth.isNotEmpty
              ? DateTime.tryParse(
                  user.dateOfBirth,
                )
              : null;
    }

    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM =
        context.watch<ProfileViewModel>();

    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: AppTheme.textLight,
          ),
        ),
        title: Text(
          l10n.profileEditTitle,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: AppTheme.primaryColor,
              ),
            )
          else ...[
            TextButton(
              onPressed:
                  profileVM.isLoading
                      ? null
                      : _cancelEditing,
              child: const Text(
                'Hủy',
                style: TextStyle(
                  color: AppTheme.textMuted,
                ),
              ),
            ),
            TextButton(
              onPressed:
                  profileVM.isLoading
                      ? null
                      : _handleSaveChanges,
              child: Text(
                l10n.profileSave,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.bgGradient,
        ),
        child: SafeArea(
          top: false,
          child: profileVM.isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        AppTheme.primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    24,
                    20,
                    24,
                    40,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(),

                      const SizedBox(height: 32),

                      const Text(
                        'THÔNG TIN CÁ NHÂN',
                        style: TextStyle(
                          color:
                              AppTheme.textMuted,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller:
                            _nameController,
                        label:
                            l10n.profileFullName,
                        hint: l10n
                            .profileFullNameHint,
                        prefixIcon:
                            Icons.person_outline,
                        enabled: _isEditing,
                        errorText:
                            profileVM.fullNameError,
                      ),

                      const SizedBox(height: 18),

                      CustomTextField(
                        controller:
                            _emailController,
                        label:
                            l10n.profileEmail,
                        hint:
                            l10n.profileEmailHint,
                        prefixIcon:
                            Icons.email_outlined,
                        enabled: _isEditing,
                        errorText:
                            profileVM.emailError,
                      ),

                      const SizedBox(height: 18),

                      CustomTextField(
                        controller:
                            _phoneController,
                        label:
                            l10n.profilePhone,
                        hint:
                            l10n.profilePhoneHint,
                        prefixIcon:
                            Icons.phone_outlined,
                        enabled: _isEditing,
                        errorText: profileVM
                            .phoneNumberError,
                      ),

                      const SizedBox(height: 26),

                      _buildGenderField(
                        profileVM,
                        l10n,
                      ),

                      const SizedBox(height: 22),

                      _buildDateField(
                        profileVM,
                        l10n,
                      ),

                      if (_isEditing) ...[
                        const SizedBox(
                            height: 34),

                        Container(
                          padding:
                              const EdgeInsets.all(
                            16,
                          ),
                          decoration:
                              BoxDecoration(
                            color: AppTheme
                                .primaryColor
                                .withValues(
                              alpha: 0.08,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            border: Border.all(
                              color: AppTheme
                                  .primaryColor
                                  .withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Icon(
                                Icons
                                    .info_outline_rounded,
                                color: AppTheme
                                    .primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Kiểm tra lại thông tin trước khi lưu. '
                                  'Các thông tin này được dùng để cá nhân hóa trải nghiệm SleepCare.',
                                  style: TextStyle(
                                    color: AppTheme
                                        .textMuted,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final name =
        _nameController.text.trim();

    String initials = 'U';

    if (name.isNotEmpty) {
      final words = name
          .split(RegExp(r'\s+'))
          .where(
            (word) => word.isNotEmpty,
          )
          .toList();

      if (words.length >= 2) {
        initials =
            '${words.first[0]}${words.last[0]}'
                .toUpperCase();
      } else {
        initials =
            words.first[0].toUpperCase();
      }
    }

    return Center(
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor
                  .withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor
                    .withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            name.isEmpty
                ? 'SleepCare User'
                : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          if (_emailController
              .text
              .isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              _emailController.text,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGenderField(
    ProfileViewModel profileVM,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileGender,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: _selectedGender,
          onChanged: !_isEditing
              ? null
              : (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
          dropdownColor:
              AppTheme.cardColor,
          icon: const Icon(
            Icons
                .keyboard_arrow_down_rounded,
            color: AppTheme.textMuted,
          ),
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor:
                AppTheme.cardLightColor,
            prefixIcon: const Icon(
              Icons.wc_outlined,
              color: AppTheme.textMuted,
            ),
            errorText:
                profileVM.sexError,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),
              borderSide:
                  BorderSide.none,
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white
                    .withValues(
                  alpha: 0.05,
                ),
              ),
            ),
            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),
              borderSide:
                  const BorderSide(
                color:
                    AppTheme.primaryColor,
              ),
            ),
          ),
          hint: Text(
            l10n.profileSelect,
            style: const TextStyle(
              color: AppTheme.textMuted,
            ),
          ),
          items: [
            DropdownMenuItem(
              value: 'Nam',
              child: Text(
                l10n.profileMale,
              ),
            ),
            DropdownMenuItem(
              value: 'Nữ',
              child: Text(
                l10n.profileFemale,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    ProfileViewModel profileVM,
    AppLocalizations l10n,
  ) {
    final hasError =
        profileVM.dateOfBirthError != null;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileDob,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          borderRadius:
              BorderRadius.circular(16),
          onTap:
              _isEditing ? _selectDate : null,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            decoration: BoxDecoration(
              color:
                  AppTheme.cardLightColor,
              borderRadius:
                  BorderRadius.circular(16),
              border: Border.all(
                color: hasError
                    ? Colors.redAccent
                    : Colors.white
                        .withValues(
                      alpha: 0.05,
                    ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons
                      .calendar_today_outlined,
                  color:
                      AppTheme.textMuted,
                  size: 20,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? l10n
                            .profileSelectDate
                        : _formatDate(
                            _selectedDate!,
                          ),
                    style: TextStyle(
                      color:
                          _selectedDate ==
                                  null
                              ? AppTheme
                                  .textMuted
                              : AppTheme
                                  .textLight,
                      fontSize: 14,
                    ),
                  ),
                ),

                if (_isEditing)
                  const Icon(
                    Icons
                        .chevron_right_rounded,
                    color:
                        AppTheme.textMuted,
                  ),
              ],
            ),
          ),
        ),

        if (hasError) ...[
          const SizedBox(height: 6),

          Padding(
            padding:
                const EdgeInsets.only(
              left: 12,
            ),
            child: Text(
              profileVM
                  .dateOfBirthError!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month
            .toString()
            .padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}