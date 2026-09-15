abstract class QuestionnaireEvent {
  const QuestionnaireEvent();
}

/// Mở trang và tải câu hỏi FULL_PSQI.
class QuestionnaireStarted extends QuestionnaireEvent {
  const QuestionnaireStarted();
}

/// Người dùng nhập hoặc thay đổi một câu trả lời.
class QuestionnaireAnswerChanged extends QuestionnaireEvent {
  final String questionId;
  final Object? value;

  const QuestionnaireAnswerChanged({
    required this.questionId,
    required this.value,
  });
}

/// Người dùng bấm hoàn thành khảo sát.
class QuestionnaireSubmitted extends QuestionnaireEvent {
  const QuestionnaireSubmitted();
}
