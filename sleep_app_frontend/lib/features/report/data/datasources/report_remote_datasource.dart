import 'package:sleep_app_frontend/features/report/domain/entities/overview_report.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/overview_report_model.dart';
import '../models/sleep_report_model.dart';
import '../models/habit_report_model.dart';
import '../models/bedtime_report_model.dart';
import '../models/music_report_model.dart';
import '../models/sleep_music_report_model.dart';

abstract class ReportRemoteDataSource {
  Future<OverviewReportModel> getOverviewReport(String userId);
  Future<SleepReportModel> getSleepReport(String userId);
  Future<HabitReportModel> getHabitReport(String userId);
  Future<BedtimeReportModel> getBedtimeReport(String userId);
  Future<MusicReportModel> getMusicReport(String userId);
  Future<SleepMusicReportModel> getSleepMusicReport(String userId);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReportRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<OverviewReportModel> getOverviewReport(String userId) async {
    final now = DateTime.now();
    // Chúng ta định nghĩa "tuần này" là 7 ngày qua, "tuần trước" là 7 ngày trước đó
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final fourteenDaysAgo = now.subtract(const Duration(days: 14));

    // 1. Lấy dữ liệu tuần này
    final currentWeekData = await supabaseClient
        .from('sleep_assessments')
        .select(
          'assessment_date, assessment_sleep_metrics(sleep_duration_minutes)',
        )
        .eq('user_id', userId)
        .eq('assessment_type', 'daily_short')
        .eq('status', 'completed')
        .gte('assessment_date', sevenDaysAgo.toIso8601String().split('T')[0]);

    double currentTotalDuration = 0;
    int currentCount = 0;

    // Tạo mảng 7 ngày để fill dữ liệu
    List<DailySleepData> weekData = List.generate(7, (index) {
      // Từ T2 (1) đến CN (7)
      return DailySleepData(
        date: now.subtract(Duration(days: now.weekday - (index + 1))),
        hasData: false,
      );
    });

    for (var item in currentWeekData) {
      final metrics = item['assessment_sleep_metrics'];
      if (metrics != null) {
        currentTotalDuration +=
            (metrics['sleep_duration_minutes'] as num?)?.toDouble() ?? 0;
        currentCount++;
      }

      final dateStr = item['assessment_date'] as String?;
      if (dateStr != null) {
        final date = DateTime.parse(dateStr);
        // Map vào thứ 2 (0) - CN (6)
        if (date.weekday >= 1 && date.weekday <= 7) {
          weekData[date.weekday - 1] = DailySleepData(
            date: date,
            hasData: true,
          );
        }
      }
    }
    final currentAvgDuration = currentCount > 0
        ? currentTotalDuration / currentCount
        : 0.0;

    // 2. Lấy dữ liệu tuần trước
    final previousWeekData = await supabaseClient
        .from('sleep_assessments')
        .select('assessment_sleep_metrics(sleep_duration_minutes)')
        .eq('user_id', userId)
        .eq('assessment_type', 'daily_short')
        .eq('status', 'completed')
        .gte('assessment_date', fourteenDaysAgo.toIso8601String().split('T')[0])
        .lt('assessment_date', sevenDaysAgo.toIso8601String().split('T')[0]);

    double previousTotalDuration = 0;
    int previousCount = 0;
    for (var item in previousWeekData) {
      final metrics = item['assessment_sleep_metrics'];
      if (metrics != null) {
        previousTotalDuration +=
            (metrics['sleep_duration_minutes'] as num?)?.toDouble() ?? 0;
        previousCount++;
      }
    }
    final previousAvgDuration = previousCount > 0
        ? previousTotalDuration / previousCount
        : 0.0;

    final deltaMinutes = (currentAvgDuration - previousAvgDuration).round();

    return OverviewReportModel(
      averageSleepDurationHours: currentAvgDuration / 60.0,
      deltaMinutes: deltaMinutes,
      weekData: weekData,
    );
  }

  @override
  Future<SleepReportModel> getSleepReport(String userId) async {
    final response = await supabaseClient
        .from('sleep_assessments')
        .select('*, assessment_sleep_metrics(*)')
        .eq('user_id', userId)
        .eq('status', 'completed')
        .order('completed_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return const SleepReportModel(
        sleepDurationHours: 0,
        sleepScore: 0,
        sleepQuality: 'Không có dữ liệu',
      );
    }

    final metrics = response['assessment_sleep_metrics'] ?? {};
    final durationMins =
        (metrics['sleep_duration_minutes'] as num?)?.toDouble() ?? 0.0;
    final score = (response['normalized_score'] as num?)?.toInt() ?? 0;
    final quality = response['quality_level'] as String? ?? 'Chưa đánh giá';

    return SleepReportModel(
      sleepDurationHours: durationMins / 60.0,
      sleepScore: score,
      sleepQuality: quality,
    );
  }

  @override
  Future<HabitReportModel> getHabitReport(String userId) async {
    return const HabitReportModel(habits: []);
  }

  @override
  Future<BedtimeReportModel> getBedtimeReport(String userId) async {
    // 1. Lấy mục tiêu giờ đi ngủ từ bảng bedtime_schedules
    final scheduleResponse = await supabaseClient
        .from('bedtime_schedules')
        .select('bedtime')
        .eq('user_id', userId)
        .maybeSingle();

    final targetBedtime = scheduleResponse != null
        ? (scheduleResponse['bedtime'] as String? ?? '22:00:00')
        : '22:00:00';
    final targetBedtimeFormatted = targetBedtime.substring(0, 5);

    // 2. Tính số ngày đạt mục tiêu trong 7 ngày qua
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final currentWeekData = await supabaseClient
        .from('sleep_assessments')
        .select('assessment_sleep_metrics(bedtime)')
        .eq('user_id', userId)
        .eq('assessment_type', 'daily_short')
        .eq('status', 'completed')
        .gte('assessment_date', sevenDaysAgo.toIso8601String().split('T')[0]);

    int daysAchieved = 0;
    for (var item in currentWeekData) {
      final metrics = item['assessment_sleep_metrics'];
      if (metrics != null && metrics['bedtime'] != null) {
        final actualBedtime = metrics['bedtime'] as String;
        // Logic so sánh giờ đơn giản
        if (actualBedtime.compareTo(targetBedtime) <= 0) {
          daysAchieved++;
        }
      }
    }

    return BedtimeReportModel(
      targetBedtime: targetBedtimeFormatted,
      daysAchieved: daysAchieved,
      totalDays: 7,
    );
  }

  @override
  Future<MusicReportModel> getMusicReport(String userId) async {
    return const MusicReportModel(
      consecutiveDays: 0,
      averageListeningMinutes: 0,
      favoriteGenre: 'Chưa có',
    );
  }

  @override
  Future<SleepMusicReportModel> getSleepMusicReport(String userId) async {
    return const SleepMusicReportModel(
      suggestionText:
          'Bạn thường ngủ tốt hơn khi nghe nhạc khoảng 30 phút trước khi ngủ.',
    );
  }
}
