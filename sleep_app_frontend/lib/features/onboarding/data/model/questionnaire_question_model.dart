import '../../domain/entities/questionnaire_question.dart';

class QuestionnaireQuestionModel extends QuestionnaireQuestion {
  const QuestionnaireQuestionModel({
    required super.id,
    required super.questionnaireVersionId,
    required super.questionCode,
    required super.questionText,
    required super.questionType,
    required super.position,
    required super.options,
    required super.isRequired,
  });

  factory QuestionnaireQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List? ?? [];

    final options = rawOptions.map((option) {
      final map = Map<String, dynamic>.from(option as Map);

      return QuestionOption(
        value: map['value'] as Object,
        label: map['label'] as String,
        score: (map['score'] as num?)?.toDouble(),
      );
    }).toList();

    return QuestionnaireQuestionModel(
      id: json['id'] as String,
      questionnaireVersionId: json['questionnaire_version_id'] as String,
      questionCode: json['question_code'] as String,
      questionText: json['question_text'] as String,
      questionType: json['question_type'] as String,
      position: json['position'] as int,
      options: options,
      isRequired: json['is_required'] as bool? ?? true,
    );
  }

  factory QuestionnaireQuestionModel.fromEntity(QuestionnaireQuestion entity) {
    return QuestionnaireQuestionModel(
      id: entity.id,
      questionnaireVersionId: entity.questionnaireVersionId,
      questionCode: entity.questionCode,
      questionText: entity.questionText,
      questionType: entity.questionType,
      position: entity.position,
      options: entity.options,
      isRequired: entity.isRequired,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionnaire_version_id': questionnaireVersionId,
      'question_code': questionCode,
      'question_text': questionText,
      'question_type': questionType,
      'position': position,
      'options': options.map((option) {
        return {
          'value': option.value,
          'label': option.label,
          'score': option.score,
        };
      }).toList(),
      'is_required': isRequired,
    };
  }

  QuestionnaireQuestion toEntity() {
    return QuestionnaireQuestion(
      id: id,
      questionnaireVersionId: questionnaireVersionId,
      questionCode: questionCode,
      questionText: questionText,
      questionType: questionType,
      position: position,
      options: options,
      isRequired: isRequired,
    );
  }
}
