class ActiveSleepSession {
  final String bedtimeSessionId;
  final String listeningSessionId;
  final DateTime startedAt;

  const ActiveSleepSession({
    required this.bedtimeSessionId,
    required this.listeningSessionId,
    required this.startedAt,
  });
}
