import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/music.dart';
import '../../domain/repositories/library_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc({required this.repository}) : super(LibraryInitial()) {
    on<LoadLibrary>(_onLoadLibrary);
    on<SearchLibrary>(_onSearchLibrary);
    on<ToggleSavedMusic>(_onToggleSavedMusic);
    on<RefreshSavedMusics>(_onRefreshSavedMusics);
  }

  final LibraryRepository repository;

  Future<void> _onLoadLibrary(
    LoadLibrary event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    try {
      final genres = await repository.getGenres();

      final results = await Future.wait(
        genres.map((genre) async {
          final musics = await repository.getMusicsByGenre(
            genre: genre,
            page: 0,
            limit: 3,
          );

          return MapEntry(genre, musics);
        }),
      );

      final Map<String, List<Music>> previews = {};

      for (final entry in results) {
        if (entry.value.isNotEmpty) {
          previews[entry.key] = entry.value;
        }
      }

      final savedTrackIds = await repository.getSavedTrackIds();

      emit(
        LibraryLoaded(
          genrePreviews: previews,
          savedTrackIds: savedTrackIds,
        ),
      );
    } catch (e, stackTrace) {
      print('LOAD LIBRARY ERROR: $e');
      print('STACK TRACE: $stackTrace');

      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _onSearchLibrary(
    SearchLibrary event,
    Emitter<LibraryState> emit,
  ) async {
    final current = state;

    if (current is! LibraryLoaded) {
      return;
    }

    final query = event.query.trim();

    if (query.isEmpty) {
      emit(
        current.copyWith(
          searchQuery: '',
          searchResults: [],
          isSearching: false,
        ),
      );

      return;
    }

    emit(
      current.copyWith(
        searchQuery: query,
        isSearching: true,
      ),
    );

    try {
      final results = await repository.searchMusics(
        query: query,
        limit: 20,
      );

      final latestState = state;

      if (latestState is! LibraryLoaded) {
        return;
      }

      if (latestState.searchQuery != query) {
        return;
      }

      emit(
        latestState.copyWith(
          searchResults: results,
          isSearching: false,
        ),
      );
    } catch (e, stackTrace) {
      print('SEARCH LIBRARY ERROR: $e');
      print('STACK TRACE: $stackTrace');

      final latestState = state;

      if (latestState is LibraryLoaded) {
        emit(
          latestState.copyWith(
            searchResults: [],
            isSearching: false,
          ),
        );
      }
    }
  }

  Future<void> _onToggleSavedMusic(
    ToggleSavedMusic event,
    Emitter<LibraryState> emit,
  ) async {
    final current = state;

    if (current is! LibraryLoaded) {
      return;
    }

    try {
      final isSaved = await repository.toggleSavedTrack(event.trackId);

      final updatedIds = Set<String>.from(current.savedTrackIds);

      if (isSaved) {
        updatedIds.add(event.trackId);
      } else {
        updatedIds.remove(event.trackId);
      }

      emit(
        current.copyWith(
          savedTrackIds: updatedIds,
        ),
      );
    } catch (e, stackTrace) {
      print('TOGGLE SAVED ERROR: $e');
      print('STACK TRACE: $stackTrace');
    }
  }

  Future<void> _onRefreshSavedMusics(
    RefreshSavedMusics event,
    Emitter<LibraryState> emit,
  ) async {
    final current = state;

    if (current is! LibraryLoaded) {
      return;
    }

    try {
      final ids = await repository.getSavedTrackIds();

      emit(
        current.copyWith(
          savedTrackIds: ids,
        ),
      );
    } catch (e, stackTrace) {
      print('REFRESH SAVED ERROR: $e');
      print('STACK TRACE: $stackTrace');
    }
  }
}