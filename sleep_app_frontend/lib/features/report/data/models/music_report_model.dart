import '../../domain/entities/music_report.dart';

class MusicReportModel extends MusicReport {
  const MusicReportModel({
    required super.consecutiveDays,
    required super.averageListeningMinutes,
    required super.favoriteGenre,
  });

  factory MusicReportModel.fromJson(Map<String, dynamic> json) {
    return MusicReportModel(
      consecutiveDays: (json['consecutive_days'] as num?)?.toInt() ?? 0,
      averageListeningMinutes: (json['average_listening_minutes'] as num?)?.toInt() ?? 0,
      favoriteGenre: json['favorite_genre'] as String? ?? 'Chưa có',
    );
  }
}
