import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Đảm bảo bạn đã thêm provider vào pubspec.yaml
import 'package:sleep_app_frontend/main.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/app/widget/custom_text_field.dart';
import '../viewmodels/profile_vm.dart'; // Thay đổi đường dẫn đúng file của bạn
import 'security_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isEditing = false;

  // Khởi tạo các controllers trống ban đầu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;

  // Lấy ID của user đang đăng nhập hiện tại từ Supabase
  final String _userId = supabaseClient.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    // Sau khi màn hình render xong, tiến hành fetch dữ liệu từ Database
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileVM = context.read<ProfileViewModel>();
      await profileVM.loadProfile(_userId);

      // Sau khi fetch xong, đổ dữ liệu từ viewModel vào các ô nhập liệu
      if (profileVM.user != null) {
        final u = profileVM.user!;
        _nameController.text = u.fullName;
        _emailController.text = u.email;
        _phoneController.text = u.phoneNumber;
        _selectedGender = u.sex.isEmpty ? null : u.sex;

        if (u.dateOfBirth.isNotEmpty) {
          _selectedDate = DateTime.tryParse(u.dateOfBirth);
        }
        setState(() {}); // Re-render để hiển thị lên UI
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Hàm chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hàm thực thi việc Lưu dữ liệu lên Database
  Future<void> _handleSaveChanges() async {
    final viewModel = context.read<ProfileViewModel>();

    // Gọi hàm update từ ViewModel
    bool success = await viewModel.updateProfile(
      id: _userId,
      fullName: _nameController.text,
      email: _emailController.text,
      sex: _selectedGender ?? '',
      dateOfBirth: _selectedDate != null
          ? _selectedDate!.toIso8601String().split('T')[0]
          : '',
      phoneNumber: _phoneController.text,
    );

    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật Profile thành công!')),
      );
      setState(() {
        _isEditing = false; // Đưa UI về lại chế độ chỉ đọc
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thất bại. Vui lòng thử lại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Theo dõi trạng thái loading của ViewModel để hiển thị vòng xoay nếu đang xử lý API
    final profileVM = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: AppTheme.textLight, fontSize: 16),
        ),
        actions: [
          // Logic hoán đổi nút Cây bút vẽ và Chữ Save
          _isEditing
              ? TextButton(
                  onPressed: profileVM.isLoading
                      ? null
                      : _handleSaveChanges, // Nhấn Save thì chạy hàm cập nhật
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditing = true; // Chuyển sang cho phép edit
                    });
                  },
                ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: profileVM.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              ) // Hiện vòng xoay khi fetch/update dữ liệu
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- CÁC TRƯỜNG DỮ LIỆU INPUT ---
                    CustomTextField(
                      controller: _nameController,
                      label: 'Họ và tên',
                      hint: 'Alex Moore',
                      prefixIcon: Icons.person_outline,
                      enabled: _isEditing,
                      errorText: profileVM.fullNameError,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email ',
                      hint: 'alex.m@example.com',
                      prefixIcon: Icons.email_outlined,
                      enabled: _isEditing,
                      errorText: profileVM.emailError,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      hint: 'Nhập số điện thoại của bạn',
                      prefixIcon: Icons.phone_outlined,
                      enabled: _isEditing,
                      errorText: profileVM.phoneNumberError,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cột Gender (Dropdown)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Giới tính',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedGender,
                                hint: const Text(
                                  'Chọn',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                                dropdownColor: AppTheme.cardLightColor,
                                disabledHint: Text(
                                  _selectedGender ?? 'Chưa chọn',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppTheme.textMuted,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppTheme.cardLightColor,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.male,
                                    color: AppTheme.textMuted,
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                items: _isEditing
                                    ? const [
                                        DropdownMenuItem(
                                          value: 'Nam',
                                          child: Text('Nam'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Nữ',
                                          child: Text('Nữ'),
                                        ),
                                      ]
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Cột Ngày sinh (DatePicker)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ngày sinh',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.cardLightColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: AppTheme.textMuted,
                                        size: 16,
                                      ),
                                      Text(
                                        _selectedDate == null
                                            ? 'Chọn ngày'
                                            : '${_selectedDate!.day} ${_getMonthName(_selectedDate!.month)} ${_selectedDate!.year}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // --- PHẦN KHÁC GIỮ NGUYÊN ---
                    const Text(
                      'Sleep Settings',
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingCard(
                      Icons.nights_stay,
                      'Sleep Goal',
                      '8.0 hours',
                      'TARGET',
                    ),
                    const SizedBox(height: 12),
                    _buildSettingCard(
                      Icons.wb_sunny,
                      'Chronotype',
                      'Early Bird',
                      '',
                    ),
                    const SizedBox(height: 40),

                    const Text(
                      'Security',
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SecurityScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardLightColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.lock_outline,
                              color: AppTheme.textLight,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Change Password',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildSettingCard(
    IconData icon,
    String title,
    String value,
    String badge,
  ) {
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
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (badge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
