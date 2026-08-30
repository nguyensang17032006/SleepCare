class MusicModel {
  final String id;
  final String description;
  final String title;
  final String audioUrl;
  final String? coverUrl;
  final List<String> genre;
  final List<String>? artist;
  final String? sleepStage;

  MusicModel({
    required this.id,
    required this.description,
    required this.title,
    required this.audioUrl,
    required this.coverUrl,
    required this.genre,
    required this.artist,
    required this.sleepStage,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    final trackGenres =
        json['track_genres'] as List<dynamic>? ?? [];

    final genres = trackGenres
        .map((item) {
          final genreData = item['genres'];

          if (genreData is Map<String, dynamic>) {
            return genreData['name']?.toString();
          }

          return null;
        })
        .whereType<String>()
        .toList();

    final trackArtists =
        json['track_artists'] as List<dynamic>? ?? [];

    final artists = trackArtists
        .map((item) {
          final artistData = item['artists'];

          if (artistData is Map<String, dynamic>) {
            return artistData['name']?.toString();
          }

          return null;
        })
        .whereType<String>()
        .toList();

    return MusicModel(
      id: json['id'].toString(),
      description:
          json['description']?.toString() ?? '',
      title:
          json['title']?.toString() ?? '',
      audioUrl:
          json['audio_url']?.toString() ?? '',
      coverUrl:
          json['cover_url']?.toString(),
      genre: genres,
      artist: artists,
      sleepStage:
          json['sleep_stage']?.toString(),
    );
  }
}