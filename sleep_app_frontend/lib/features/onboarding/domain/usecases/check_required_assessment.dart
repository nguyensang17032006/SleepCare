import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/assessment_requirement.dart';
import '../repositories/onboarding_repository.dart';

class CheckRequiredAssessment {
  final OnboardingRepository repository;

  const CheckRequiredAssessment(this.repository);

  Future<Either<Failure, AssessmentRequirement>> call() {
    return repository.checkRequiredAssessment();
  }
}
