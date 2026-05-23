import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/report/presentation/widget/bar_chart_widget.dart';
import 'package:sleep_app_frontend/features/report/presentation/widget/line_chart_widget.dart';
import '../../../core/theme/theme.dart';
import '../../../core/app/widget/primary_button.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

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
              const Text(
                'INSIGHTS ENGINE',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Sleep\nArchitecture',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Average Duration',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                '7.5',
                                style: TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              SizedBox(width: 4),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  'hours',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.greenAccent,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '12% more sleep than last week',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.nightlight_round,
                      color: AppTheme.primaryColor,
                      size: 48,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const BarChartWidget(),

              const SizedBox(height: 30),

              const LineChartWidget(weeklySpots: [], monthlySpots: []),

              const SizedBox(height: 30),

              const Text(
                'PILLOW TALK',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildInsightCard(
                Icons.lightbulb_outline,
                'Nightly Rhythms',
                'Your sleep latency was noticeably improved by 15% during REM cycles. Some evening deep tones worked well for you last month.',
              ),

              const SizedBox(height: 12),

              _buildInsightCard(
                Icons.star_outline,
                'Pillow Talk',
                'Consistency is key. Your 10:30 PM bed time is becoming a normal routine for your circadian body.',
              ),
              const SizedBox(height: 30),

              PrimaryButton(text: 'Generate Full PDF Report', onPressed: () {}),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.cardLightColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
