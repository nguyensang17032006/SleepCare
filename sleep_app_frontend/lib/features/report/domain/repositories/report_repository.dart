import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/overview_report.dart';
import '../entities/sleep_report.dart';
import '../entities/habit_report.dart';
import '../entities/bedtime_report.dart';
import '../entities/music_report.dart';
import '../entities/sleep_music_report.dart';

abstract class ReportRepository {
  Future<Either<Failure, OverviewReport>> getOverviewReport(String userId);
  Future<Either<Failure, SleepReport>> getSleepReport(String userId);
  Future<Either<Failure, HabitReport>> getHabitReport(String userId);
  Future<Either<Failure, BedtimeReport>> getBedtimeReport(String userId);
  Future<Either<Failure, MusicReport>> getMusicReport(String userId);
  Future<Either<Failure, SleepMusicReport>> getSleepMusicReport(String userId);
}
