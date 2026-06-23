import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController? controller;
  
  // 1. Thêm thuộc tính errorText (Nếu null là không có lỗi, nếu có chữ là đang lỗi)
  final String? errorText; 

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.controller,
    this.errorText, // Khai báo ở constructor
  });

  @override
  Widget build(BuildContext context) {
    // 2. Kiểm tra xem ô này có đang bị lỗi hay không
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        
        // 3. Thay đổi border của Container dựa vào trạng thái lỗi
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardLightColor,
            borderRadius: BorderRadius.circular(16),
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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppTheme.textMuted.withValues(alpha: 0.5),
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: hasError ? Colors.red.withValues(alpha: 0.7) : AppTheme.textMuted, size: 20)
                  : null,
              suffixIcon: onSuffixIconPressed != null
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: onSuffixIconPressed,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        
        // 4. Nếu có lỗi, hiển thị dòng chữ thông báo màu đỏ ngay phía dưới ô nhập liệu
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}