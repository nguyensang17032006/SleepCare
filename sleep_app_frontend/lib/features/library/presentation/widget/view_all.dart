import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';

class ViewAllWidget extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const ViewAllWidget({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textLight,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            AppLocalizations.of(context)!.libraryViewAll,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
