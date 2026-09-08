import 'package:sleep_app_frontend/features/library/data/datasource/library_remote_datasource.dart';
import 'package:sleep_app_frontend/features/library/data/models/music_model.dart';

import '../../domain/entities/music.dart';
import '../../domain/repositories/library_repository.dart';

class LibraryRepositoryImpl
    implements LibraryRepository {
  const LibraryRepositoryImpl({
    required this.remoteDatasource,
  });

  final LibraryRemoteDatasource
      remoteDatasource;

  Music _toEntity(MusicModel model) {
    return Music(
      id: model.id,
      description: model.description,
      title: model.title,
      audioUrl: model.audioUrl,
      coverUrl: model.coverUrl,
      genre: model.genre,
      artist: model.artist,
      sleepStage: model.sleepStage,
    );
  }

  @override
  Future<List<String>> getGenres() {
    return remoteDatasource.getGenres();
  }

  @override
  Future<List<Music>> getMusicsByGenre({
    required String genre,
    required int page,
    required int limit,
  }) async {
    final models =
        await remoteDatasource
            .getMusicsByGenre(
      genre: genre,
      page: page,
      limit: limit,
    );

    return models
        .map(_toEntity)
        .toList();
  }

  @override
  Future<List<Music>> searchMusics({
    required String query,
    int limit = 20,
  }) async {
    final models =
        await remoteDatasource
            .searchMusics(
      query: query,
      limit: limit,
    );

    return models
        .map(_toEntity)
        .toList();
  }

  @override
  Future<Set<String>>
      getSavedTrackIds() {
    return remoteDatasource
        .getSavedTrackIds();
  }

  @override
  Future<bool> toggleSavedTrack(
    String trackId,
  ) {
    return remoteDatasource
        .toggleSavedTrack(trackId);
  }

  @override
  Future<List<Music>>
      getSavedMusics() async {
    final models =
        await remoteDatasource
            .getSavedMusics();

    return models
        .map(_toEntity)
        .toList();
  }
}