import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/constants/app_size.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Function() onProfileTap;

  const AppBarWidget({super.key, required this.onProfileTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Text(
        'Sleep Care',
        style: TextStyle(
          color: AppTheme.textLight,
          fontSize: AppSizes.f24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onProfileTap,
          child: Padding(
            padding:  EdgeInsets.only(right: AppSizes.vGap16),
            child: CircleAvatar(
              backgroundColor: AppTheme.cardLightColor,
              radius: AppSizes.vGap16,
              child: Image.asset(
                'assets/images/logo.png',
                width: AppSizes.vGap16,
                height: AppSizes.vGap16,
                errorBuilder: (_, _, _) =>
                     Icon(Icons.person, size: AppSizes.vGap16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
