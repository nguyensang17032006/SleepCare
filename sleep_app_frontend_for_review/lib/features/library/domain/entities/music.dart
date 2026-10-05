class Music {
  final String id;
  final String description;
  final String title;
  final String audioUrl;
  final String? coverUrl;
  final List<String> genre;
  final List<String>? artist;
  final String? sleepStage;

  const Music({
    required this.id,
    required this.description,
    required this.title,
    required this.audioUrl,
    required this.coverUrl,
    required this.genre,
    required this.artist,
    required this.sleepStage,
  });
}