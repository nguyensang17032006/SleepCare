import '../../domain/entities/music.dart';

abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  LibraryLoaded({
    required this.genrePreviews,
    required this.savedTrackIds,
    this.searchResults = const [],
    this.searchQuery = '',
    this.isSearching = false,
  });

  final Map<String, List<Music>>
      genrePreviews;

  final Set<String> savedTrackIds;

  final List<Music> searchResults;

  final String searchQuery;

  final bool isSearching;

  LibraryLoaded copyWith({
    Map<String, List<Music>>?
        genrePreviews,
    Set<String>? savedTrackIds,
    List<Music>? searchResults,
    String? searchQuery,
    bool? isSearching,
  }) {
    return LibraryLoaded(
      genrePreviews:
          genrePreviews ??
              this.genrePreviews,
      savedTrackIds:
          savedTrackIds ??
              this.savedTrackIds,
      searchResults:
          searchResults ??
              this.searchResults,
      searchQuery:
          searchQuery ??
              this.searchQuery,
      isSearching:
          isSearching ??
              this.isSearching,
    );
  }
}

class LibraryError extends LibraryState {
  LibraryError(this.message);

  final String message;
}