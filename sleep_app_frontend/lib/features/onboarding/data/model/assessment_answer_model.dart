import '../../domain/entities/assessment_answer.dart';

class AssessmentAnswerModel extends AssessmentAnswer {
  const AssessmentAnswerModel({
    super.id,
    super.assessmentId,
    required super.questionId,
    required super.answerValue,
    super.answerScore,
    super.answeredAt,
  });

  factory AssessmentAnswerModel.fromJson(Map<String, dynamic> json) {
    return AssessmentAnswerModel(
      id: json['id'] as String?,
      assessmentId: json['assessment_id'] as String?,
      questionId: json['question_id'] as String,
      answerValue: json['answer_value'],
      answerScore: (json['answer_score'] as num?)?.toDouble(),
      answeredAt: json['answered_at'] == null
          ? null
          : DateTime.parse(json['answered_at'] as String),
    );
  }

  factory AssessmentAnswerModel.fromEntity(AssessmentAnswer entity) {
    return AssessmentAnswerModel(
      id: entity.id,
      assessmentId: entity.assessmentId,
      questionId: entity.questionId,
      answerValue: entity.answerValue,
      answerScore: entity.answerScore,
      answeredAt: entity.answeredAt,
    );
  }

  Map<String, dynamic> toJson({String? assessmentIdOverride}) {
    final finalAssessmentId = assessmentIdOverride ?? assessmentId;

    if (finalAssessmentId == null) {
      throw StateError(
        'assessmentId chưa được tạo nên không thể lưu câu trả lời.',
      );
    }

    final json = <String, dynamic>{
      'assessment_id': finalAssessmentId,
      'question_id': questionId,
      'answer_value': answerValue,
      'answer_score': answerScore,
      'answered_at': answeredAt?.toUtc().toIso8601String(),
    };

    json.removeWhere((key, value) => value == null);

    return json;
  }

  AssessmentAnswer toEntity() {
    return AssessmentAnswer(
      id: id,
      assessmentId: assessmentId,
      questionId: questionId,
      answerValue: answerValue,
      answerScore: answerScore,
      answeredAt: answeredAt,
    );
  }
}
