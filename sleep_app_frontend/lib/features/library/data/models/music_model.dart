class MusicModel {
  final String id;
  final String description;
  final String title;
  final String audioUrl;
  final String? coverUrl;
  final List<String> genre;
  final List<String>? artist;

  MusicModel({
    required this.id,
    required this.description,
    required this.title,
    required this.audioUrl,
    required this.coverUrl,
    required this.genre,
    required this.artist,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      audioUrl: json['audio_url'] as String,
      coverUrl: json['cover_url'] as String?,
      genre:
          (json['genre'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      artist:
          (json['artist'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
