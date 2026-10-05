import 'package:flutter/material.dart';

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  static bool hasMinimumLength(String password) => password.length >= 8;

  static bool startsWithUppercase(String password) =>
      RegExp(r'^[A-Z]').hasMatch(password);

  static bool hasNumber(String password) => RegExp(r'\d').hasMatch(password);

  static bool hasSpecialCharacter(String password) =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(password);

  static bool isValid(String password) =>
      hasMinimumLength(password) &&
      startsWithUppercase(password) &&
      hasNumber(password) &&
      hasSpecialCharacter(password);

  @override
  Widget build(BuildContext context) {
    final requirements = [
      ('Ít nhất 8 ký tự', hasMinimumLength(password)),
      ('Ký tự đầu tiên là chữ hoa', startsWithUppercase(password)),
      ('Có ít nhất một ký tự số', hasNumber(password)),
      ('Có ít nhất một ký tự đặc biệt', hasSpecialCharacter(password)),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: requirements.map((requirement) {
          final isValid = requirement.$2;
          final color = isValid ? Colors.greenAccent : Colors.redAccent;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle : Icons.cancel,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  requirement.$1,
                  style: TextStyle(color: color, fontSize: 12),
                ),
                
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
