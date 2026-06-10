import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search frequencies, nature, or moods',
          hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: AppTheme.textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
