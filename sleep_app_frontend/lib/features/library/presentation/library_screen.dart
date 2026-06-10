import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/library/presentation/widget/search_box.dart';
import 'package:sleep_app_frontend/features/library/presentation/widget/view_all.dart';
import '../../../core/theme/theme.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBox(),
              const SizedBox(height: 30),

              const Text(
                'PERSONALIZED',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ViewAllWidget(title: 'Recommended for You', onViewAll: () {}),
              const SizedBox(height: 16),

              _buildRecommendedCard(
                'Lunar Echoes',
                'Frequency 432Hz',
                'NEW',
                Icons.nightlight_round,
                const Color(0xFF6B429A),
              ),
              const SizedBox(height: 16),
              _buildRecommendedCard(
                'Mist & Moss',
                'Atmospheric',
                'NEW',
                Icons.forest,
                const Color(0xFF2C5E47),
              ),
              const SizedBox(height: 30),

              const Text(
                'ATMOSPHERE 3D',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              ViewAllWidget(title: 'Nature Music', onViewAll: () {}),

              const SizedBox(height: 16),

              _buildMusicListTile(
                'Midnight Ballad',
                'Nature • 45:00',
                Icons.water,
              ),
              _buildMusicListTile(
                'Ember Glow',
                'Nature • 30:00',
                Icons.local_fire_department,
              ),
              _buildMusicListTile(
                'Lunar Echoes',
                'Frequency 432Hz',
                Icons.nightlight_round,
                isActive: true,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedCard(
    String title,
    String subtitle,
    String badge,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicListTile(
    String title,
    String subtitle,
    IconData icon, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryColor.withValues(alpha: 0.2)
                  : AppTheme.cardLightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isActive
                        ? AppTheme.primaryColor
                        : AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.favorite_border, color: AppTheme.textMuted, size: 20),
          const SizedBox(width: 16),
          isActive
              ? const Icon(
                  Icons.pause_circle_filled,
                  color: AppTheme.primaryColor,
                  size: 28,
                )
              : const Icon(
                  Icons.more_vert,
                  color: AppTheme.textMuted,
                  size: 24,
                ),
        ],
      ),
    );
  }
}
