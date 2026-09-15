import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/overview_report.dart';
import '../../domain/entities/sleep_report.dart';
import '../../domain/entities/habit_report.dart';
import '../../domain/entities/bedtime_report.dart';
import '../../domain/entities/music_report.dart';
import '../../domain/entities/sleep_music_report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OverviewReport>> getOverviewReport(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.getOverviewReport(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SleepReport>> getSleepReport(String userId) async {
    try {
      final result = await remoteDataSource.getSleepReport(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HabitReport>> getHabitReport(String userId) async {
    try {
      final result = await remoteDataSource.getHabitReport(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BedtimeReport>> getBedtimeReport(String userId) async {
    try {
      final result = await remoteDataSource.getBedtimeReport(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MusicReport>> getMusicReport(String userId) async {
    try {
      final result = await remoteDataSource.getMusicReport(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SleepMusicReport>> getSleepMusicReport(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.getSleepMusicReport(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
