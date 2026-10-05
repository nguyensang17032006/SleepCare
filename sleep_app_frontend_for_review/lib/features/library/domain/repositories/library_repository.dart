import '../entities/music.dart';

abstract class LibraryRepository {
  Future<List<String>> getGenres();

  Future<List<Music>> getMusicsByGenre({
    required String genre,
    required int page,
    required int limit,
  });

  Future<List<Music>> searchMusics({
    required String query,
    int limit = 20,
  });

  Future<Set<String>> getSavedTrackIds();

  Future<bool> toggleSavedTrack(
    String trackId,
  );

  Future<List<Music>> getSavedMusics();
}