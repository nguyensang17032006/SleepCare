abstract class LibraryEvent {}

class LoadLibrary extends LibraryEvent {}

class SearchLibrary extends LibraryEvent {
  SearchLibrary(this.query);

  final String query;
}

class ToggleSavedMusic
    extends LibraryEvent {
  ToggleSavedMusic(this.trackId);

  final String trackId;
}

class RefreshSavedMusics
    extends LibraryEvent {}