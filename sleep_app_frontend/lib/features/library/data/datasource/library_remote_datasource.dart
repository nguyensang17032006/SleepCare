import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/music_model.dart';

class LibraryRemoteDatasource {
  LibraryRemoteDatasource({required this.supabase});

  final SupabaseClient supabase;

  static const String _trackSelect = '''
    id,
    title,
    description,
    audio_url,
    cover_url,
    sleep_stage,
    track_genres(
      genres(
        name
      )
    ),
    track_artists(
      artists(
        name
      )
    )
  ''';

  static const String _trackSelectWithGenre = '''
    id,
    title,
    description,
    audio_url,
    cover_url,
    sleep_stage,
    track_genres!inner(
      genres!inner(
        name
      )
    ),
    track_artists(
      artists(
        name
      )
    )
  ''';

  static const String _trackSelectWithArtist = '''
    id,
    title,
    description,
    audio_url,
    cover_url,
    sleep_stage,
    track_genres(
      genres(
        name
      )
    ),
    track_artists!inner(
      artists!inner(
        name
      )
    )
  ''';

  // =========================================================
  // GET GENRES
  // =========================================================

  Future<List<String>> getGenres() async {
    final response = await supabase.from('genres').select('name').order('name');

    return (response as List)
        .map((item) => item['name']?.toString())
        .whereType<String>()
        .where((name) => name.trim().isNotEmpty)
        .toList();
  }

  // =========================================================
  // GET MUSIC BY GENRE - PAGINATION
  // =========================================================

  Future<List<MusicModel>> getMusicsByGenre({
    required String genre,
    required int page,
    required int limit,
  }) async {
    final from = page * limit;
    final to = from + limit - 1;

    final response = await supabase
        .from('tracks')
        .select(_trackSelectWithGenre)
        .eq('is_published', true)
        .eq('track_genres.genres.name', genre)
        .order('published_at', ascending: false)
        .range(from, to);

    return (response as List)
        .map((json) => MusicModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // =========================================================
  // SEARCH
  // title + description + sleep_stage + genre + artist
  // =========================================================

  Future<List<MusicModel>> searchMusics({
    required String query,
    int limit = 20,
  }) async {
    final cleanQuery = query.trim().replaceAll(',', ' ');

    if (cleanQuery.isEmpty) {
      return [];
    }

    final pattern = '%$cleanQuery%';

    final Map<String, MusicModel> unique = {};

    // title / description / sleep stage
    final textResponse = await supabase
        .from('tracks')
        .select(_trackSelect)
        .eq('is_published', true)
        .or(
          'title.ilike.$pattern,'
          'description.ilike.$pattern,'
          'sleep_stage.ilike.$pattern',
        )
        .limit(limit);

    for (final item in textResponse as List) {
      final model = MusicModel.fromJson(Map<String, dynamic>.from(item));

      unique[model.id] = model;
    }

    // genre
    final genreResponse = await supabase
        .from('tracks')
        .select(_trackSelectWithGenre)
        .eq('is_published', true)
        .ilike('track_genres.genres.name', pattern)
        .limit(limit);

    for (final item in genreResponse as List) {
      final model = MusicModel.fromJson(Map<String, dynamic>.from(item));

      unique[model.id] = model;
    }

    // artist
    final artistResponse = await supabase
        .from('tracks')
        .select(_trackSelectWithArtist)
        .eq('is_published', true)
        .ilike('track_artists.artists.name', pattern)
        .limit(limit);

    for (final item in artistResponse as List) {
      final model = MusicModel.fromJson(Map<String, dynamic>.from(item));

      unique[model.id] = model;
    }

    return unique.values.take(limit).toList();
  }

  // =========================================================
  // USER PLAYLIST
  // 1 USER = 1 PLAYLIST
  // =========================================================

  Future<String?> getUserPlaylistId() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return null;
    }

    final playlist = await supabase
        .from('playlists')
        .select('id')
        .eq('owner_user_id', userId)
        .limit(1)
        .maybeSingle();

    if (playlist != null) {
      return playlist['id'].toString();
    }

    final created = await supabase
        .from('playlists')
        .insert({
          'owner_user_id': userId,
          'name': 'Bài hát của bạn',
          'description': 'Danh sách bài hát đã lưu',
          'playlist_type': 'user',
          'is_public': false,
        })
        .select('id')
        .single();

    return created['id'].toString();
  }

  Future<Set<String>> getSavedTrackIds() async {
    final playlistId = await getUserPlaylistId();

    if (playlistId == null) {
      return {};
    }

    final response = await supabase
        .from('playlist_tracks')
        .select('track_id')
        .eq('playlist_id', playlistId);

    return (response as List)
        .map((item) => item['track_id'].toString())
        .toSet();
  }

  Future<bool> toggleSavedTrack(String trackId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final playlistId = await getUserPlaylistId();
    if (playlistId == null) return false;

    final existing = await supabase
        .from('playlist_tracks')
        .select('track_id')
        .eq('playlist_id', playlistId)
        .eq('track_id', trackId)
        .limit(1)
        .maybeSingle();

    if (existing != null) {
      await supabase
          .from('playlist_tracks')
          .delete()
          .eq('playlist_id', playlistId)
          .eq('track_id', trackId);

      return false;
    }

    final lastTrack = await supabase
        .from('playlist_tracks')
        .select('position')
        .eq('playlist_id', playlistId)
        .order('position', ascending: false)
        .limit(1)
        .maybeSingle();

    final nextPosition = lastTrack == null
        ? 1
        : ((lastTrack['position'] as int? ?? 0) + 1);

    await supabase.from('playlist_tracks').insert({
      'playlist_id': playlistId,
      'track_id': trackId,
      'position': nextPosition,
      'added_by': userId,
    });

    return true;
  }

  // =========================================================
  // GET USER SAVED MUSICS
  // =========================================================

  Future<List<MusicModel>> getSavedMusics() async {
    final playlistId = await getUserPlaylistId();

    if (playlistId == null) {
      return [];
    }

    final playlistTracks = await supabase
        .from('playlist_tracks')
        .select('track_id, position')
        .eq('playlist_id', playlistId)
        .order('position', ascending: true);

    if ((playlistTracks as List).isEmpty) {
      return [];
    }

    final trackIds = playlistTracks
        .map((item) => item['track_id'].toString())
        .toList();

    final response = await supabase
        .from('tracks')
        .select(_trackSelect)
        .inFilter('id', trackIds);

    final models = (response as List)
        .map((json) => MusicModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();

    // Supabase query theo IN không đảm bảo
    // giữ đúng thứ tự playlist.
    final Map<String, MusicModel> map = {
      for (final music in models) music.id: music,
    };

    return trackIds.map((id) => map[id]).whereType<MusicModel>().toList();
  }
}
