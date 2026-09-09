import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/bedtime_report.dart';
import '../../domain/entities/habit_report.dart';
import '../../domain/entities/music_report.dart';
import '../../domain/entities/overview_report.dart';
import '../../domain/entities/sleep_music_report.dart';
import '../../domain/entities/sleep_report.dart';
import '../../domain/repositories/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc({required this.repository}) : super(ReportInitial()) {
    on<LoadReportData>(_onLoadReportData);
  }

  Future<void> _onLoadReportData(
    LoadReportData event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    // Fetch all data in parallel
    final results = await Future.wait([
      repository.getOverviewReport(event.userId),
      repository.getSleepReport(event.userId),
      repository.getHabitReport(event.userId),
      repository.getBedtimeReport(event.userId),
      repository.getMusicReport(event.userId),
      repository.getSleepMusicReport(event.userId),
    ]);

    // Check if any request failed
    for (final result in results) {
      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null);
        emit(ReportError(message: failure?.message ?? "Có lỗi xảy ra khi lấy dữ liệu báo cáo"));
        return;
      }
    }

    // Extract successful data
    final overviewReport = results[0].fold((l) => throw Exception(), (r) => r as OverviewReport);
    final sleepReport = results[1].fold((l) => throw Exception(), (r) => r as SleepReport);
    final habitReport = results[2].fold((l) => throw Exception(), (r) => r as HabitReport);
    final bedtimeReport = results[3].fold((l) => throw Exception(), (r) => r as BedtimeReport);
    final musicReport = results[4].fold((l) => throw Exception(), (r) => r as MusicReport);
    final sleepMusicReport = results[5].fold((l) => throw Exception(), (r) => r as SleepMusicReport);

    emit(
      ReportLoaded(
        overviewReport: overviewReport,
        sleepReport: sleepReport,
        habitReport: habitReport,
        bedtimeReport: bedtimeReport,
        musicReport: musicReport,
        sleepMusicReport: sleepMusicReport,
      ),
    );
  }
}
