sealed class DailyShortEvent {
  const DailyShortEvent();
}

class DailyShortStarted extends DailyShortEvent {
  const DailyShortStarted();
}

class DailyShortAnswerChanged extends DailyShortEvent {
  final String questionId;
  final Object? value;

  const DailyShortAnswerChanged({
    required this.questionId,
    required this.value,
  });
}

class DailyShortSubmitted extends DailyShortEvent {
  const DailyShortSubmitted();
}
