import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;

  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE5D1B2),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0D1226),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 20),

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

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
          ),
        ),
      ],
    );
  }
}
