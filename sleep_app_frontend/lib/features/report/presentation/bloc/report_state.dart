part of 'report_bloc.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}

final class ReportLoading extends ReportState {}

final class ReportLoaded extends ReportState {
  final OverviewReport overviewReport;
  final SleepReport sleepReport;
  final HabitReport habitReport;
  final BedtimeReport bedtimeReport;
  final MusicReport musicReport;
  final SleepMusicReport sleepMusicReport;

  ReportLoaded({
    required this.overviewReport,
    required this.sleepReport,
    required this.habitReport,
    required this.bedtimeReport,
    required this.musicReport,
    required this.sleepMusicReport,
  });
}

final class ReportError extends ReportState {
  final String message;
  ReportError({required this.message});
}
