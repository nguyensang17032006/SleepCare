import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/report/presentation/widget/bar_chart_widget.dart';
import 'package:sleep_app_frontend/features/report/presentation/widget/line_chart_widget.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/app/widget/primary_button.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.reportInsightsEngine,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.reportSleepArchitecture,
                style: const TextStyle(
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
                          Text(
                            l10n.reportAvgDuration,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '7.5',
                                style: TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  l10n.reportHours,
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_upward,
                                color: Colors.greenAccent,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.reportMoreSleep,
                                style: const TextStyle(
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

              Text(
                l10n.reportPillowTalkTitle,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildInsightCard(
                Icons.lightbulb_outline,
                l10n.reportNightlyRhythms,
                l10n.reportNightlyRhythmsDesc,
              ),

              const SizedBox(height: 12),

              _buildInsightCard(
                Icons.star_outline,
                l10n.reportPillowTalk,
                l10n.reportPillowTalkDesc,
              ),
              const SizedBox(height: 30),

              PrimaryButton(text: l10n.reportGeneratePdf, onPressed: () {}),
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
