import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import '../../theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController? controller;
  final bool? enabled;
  
 
  final String? errorText; 

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.controller,
    this.errorText, 
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {

    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style:  TextStyle(
            color: AppTheme.textMuted,
            fontSize: AppSizes.f10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: AppSizes.vGap8),
        
        // 3. Thay đổi border của Container dựa vào trạng thái lỗi
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardLightColor,
            borderRadius: BorderRadius.circular(AppSizes.r16),
            border: Border.all(
              color: hasError 
                  ? Colors.red.withValues(alpha: 0.8) // Đỏ rực lên khi có lỗi
                  : Colors.white.withValues(alpha: 0.05), // Bình thường
              width: hasError ? 1.5 : 1.0, // Tăng độ dày viền lỗi để dễ nhìn
            ),
          ),
          child: TextField(
            obscureText: obscureText,
            controller: controller,
            enabled: enabled,
            style:  TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:  TextStyle(
                color: AppTheme.textMuted.withValues(alpha: 0.5),
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: hasError ? Colors.red.withValues(alpha: 0.7) : AppTheme.textMuted, size: AppSizes.f24)
                  : null,
              suffixIcon: onSuffixIconPressed != null
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: AppSizes.f16,
                      ),
                      onPressed: onSuffixIconPressed,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:  EdgeInsets.symmetric(
                horizontal: AppSizes.vGap12,
                vertical: AppSizes.vGap12,
              ),
            ),
          ),
        ),
        
        // 4. Nếu có lỗi, hiển thị dòng chữ thông báo màu đỏ ngay phía dưới ô nhập liệu
        if (hasError) ...[
          SizedBox(height: AppSizes.vGap8),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              errorText!,
              style:  TextStyle(
                color: Colors.redAccent,
                fontSize: AppSizes.f12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}