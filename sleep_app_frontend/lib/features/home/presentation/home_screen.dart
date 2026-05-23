import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/home_header.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/home_recommended_track.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/home_sleep_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF00142B),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: [
                HeaderWidget(),

                SizedBox(height: 20),

                SleepTimer(size: size),

                SizedBox(height: 20),

                RecommendedTrack(size: size),

                SizedBox(height: size.height * 0.13),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
