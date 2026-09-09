import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/questionnaire_question.dart';
import '../repositories/onboarding_repository.dart';

class GetActiveQuestions {
  final OnboardingRepository repository;

  const GetActiveQuestions(this.repository);

  Future<Either<Failure, List<QuestionnaireQuestion>>> call({
    required String questionnaireCode,
  }) {
    return repository.getActiveQuestions(questionnaireCode: questionnaireCode);
  }
}
