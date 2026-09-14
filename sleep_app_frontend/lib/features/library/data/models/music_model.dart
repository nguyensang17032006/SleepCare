import '../../domain/entities/music.dart';

class MusicModel extends Music {
  const MusicModel({
    required super.id,
    required super.description,
    required super.title,
    required super.audioUrl,
    required super.coverUrl,
    required super.genre,
    required super.artist,
    required super.sleepStage,
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