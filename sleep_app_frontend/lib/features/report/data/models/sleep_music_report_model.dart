import '../../domain/entities/sleep_music_report.dart';

class SleepMusicReportModel extends SleepMusicReport {
  const SleepMusicReportModel({
    required super.suggestionText,
  });

  factory SleepMusicReportModel.fromJson(Map<String, dynamic> json) {
    return SleepMusicReportModel(
      suggestionText: json['suggestion_text'] as String? ?? 'Không có gợi ý.',
    );
  }
}
