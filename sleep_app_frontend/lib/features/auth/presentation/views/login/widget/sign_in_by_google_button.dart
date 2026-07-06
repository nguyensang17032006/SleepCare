import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import '../../../viewmodels/auth_vm.dart';
import 'package:provider/provider.dart';

class SignInByGoogleButton extends StatelessWidget {
  const SignInByGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () async {
          final authVM = context.read<AuthViewModel>();

          // Chỉ gọi hàm kích hoạt mở Browser đăng nhập Google
          await authVM.signInWithGoogle();

          if (context.mounted) {
            // Nếu có lỗi trong quá trình khởi động Browser thì hiển thị
            if (authVM.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(authVM.errorMessage!)));
            }
          }
        },
        icon: Image.asset(
          'assets/images/google.png',
          width: 20,
          height: 20,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.g_mobiledata, color: Colors.white),
        ),
        label: Text(
          'Đăng nhập bằng Google',
          style: TextStyle(color: Colors.white, fontSize: AppSizes.f16),
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
