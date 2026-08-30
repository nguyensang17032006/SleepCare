import 'package:flutter/material.dart';

import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBox({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.librarySearchHint,
          hintStyle: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textMuted,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
      ),
    );
  }
}