import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/daily_sleep_score.dart';
import '../repositories/onboarding_repository.dart';

class GetDailySleepScores {
  final OnboardingRepository repository;

  const GetDailySleepScores(this.repository);

  Future<Either<Failure, List<DailySleepScore>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.getDailySleepScores(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
