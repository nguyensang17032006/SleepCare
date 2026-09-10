import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_app_frontend/features/report/presentation/bloc/report_bloc.dart';
import '../../../core/theme/theme.dart';
import '../domain/entities/bedtime_report.dart';
import '../domain/entities/music_report.dart';
import '../domain/entities/overview_report.dart';
import '../domain/entities/sleep_music_report.dart';
import '../domain/entities/sleep_report.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportScreen extends StatefulWidget {
  final VoidCallback onOpenSleep;
  const ReportScreen({super.key, required this.onOpenSleep});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    context.read<ReportBloc>().add(LoadReportData(userId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              if (state is ReportLoading || state is ReportInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              } else if (state is ReportError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else if (state is ReportLoaded) {
                return _buildDashboard(context, state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, ReportLoaded state) {
    final name =
        Supabase.instance.client.auth.currentUser?.userMetadata?['full_name']
            as String?;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Good morning, $name",
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            "Theo dõi giấc ngủ của bạn",
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _buildSleepReportCard(state.sleepReport),
          const SizedBox(height: 16),

          _buildOverviewCard(state.overviewReport),
          const SizedBox(height: 16),

          _buildBedtimeGoalCard(state.bedtimeReport),
          const SizedBox(height: 16),

          _buildMusicHabitCard(state.musicReport),
          const SizedBox(height: 16),

          _buildSuggestionCard(state.sleepMusicReport),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: child,
    );
  }

  Widget _buildSleepReportCard(SleepReport report) {
    final hours = report.sleepDurationHours.floor();
    final minutes = ((report.sleepDurationHours - hours) * 60).round();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.nightlight_round,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "GIẤC NGỦ ĐÊM QUA",
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "${hours}h ${minutes}m",
                        style: const TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Thời gian ngủ",
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${report.sleepQuality}    ${report.sleepScore}/100",
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(OverviewReport report) {
    final hours = report.averageSleepDurationHours.floor();
    final minutes = ((report.averageSleepDurationHours - hours) * 60).round();
    final isUp = report.deltaMinutes >= 0;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "TUẦN NÀY",
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var day in ["T2", "T3", "T4", "T5", "T6", "T7", "CN"])
                Column(
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: day != "CN"
                            ? AppTheme.primaryColor
                            : AppTheme.cardColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            "Trung bình: ${hours}h ${minutes.toString().padLeft(2, '0')}m",
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                "So với tuần trước: ",
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
              Icon(
                isUp ? Icons.arrow_upward : Icons.arrow_downward,
                color: isUp ? Colors.greenAccent : Colors.redAccent,
                size: 14,
              ),
              Text(
                " ${report.deltaMinutes.abs()} phút",
                style: TextStyle(
                  color: isUp ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBedtimeGoalCard(BedtimeReport report) {
    double progress = report.daysAchieved / report.totalDays;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.track_changes,
                color: Colors.orangeAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "MỤC TIÊU",
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Ngủ trước ${report.targetBedtime}",
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.cardColor,
                    color: Colors.orangeAccent,
                    minHeight: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${report.daysAchieved}/${report.totalDays} ngày",
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMusicHabitCard(MusicReport report) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.music_note,
                color: Colors.purpleAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "THÓI QUEN NGHE NHẠC",
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                "${report.consecutiveDays} ngày liên tiếp",
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.headphones, color: AppTheme.textMuted, size: 16),
              const SizedBox(width: 8),
              Text(
                "${report.averageListeningMinutes} phút/ngày",
                style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.nightlight, color: AppTheme.textMuted, size: 16),
              const SizedBox(width: 8),
              Text(
                "${report.favoriteGenre} là thể loại yêu thích",
                style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(SleepMusicReport report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.8),
            AppTheme.primaryColor.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.yellowAccent, size: 20),
              const SizedBox(width: 8),
              const Text(
                "GỢI Ý CHO TỐI NAY",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"${report.suggestionText}"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onOpenSleep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Bắt đầu thư giãn",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
