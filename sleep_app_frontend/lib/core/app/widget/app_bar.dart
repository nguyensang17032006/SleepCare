import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Function() onProfileTap;

  const AppBarWidget({super.key, required this.onProfileTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Sleep Care',
        style: TextStyle(
          color: AppTheme.textLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onProfileTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.cardLightColor,
              radius: 16,
              child: Image.asset(
                'assets/images/logo.png',
                width: 20,
                height: 20,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.person, size: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
