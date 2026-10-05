import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/audio_player_service.dart';
import '../../../core/theme/theme.dart';
import '../domain/entities/music.dart';
import 'bloc/library_bloc.dart';
import 'bloc/library_event.dart';
import 'bloc/library_state.dart';
import 'genre/genre_tracks_screen.dart';
import 'player/music_player_screen.dart';
import 'playlist/user_playlist_screen.dart';
import 'widget/music_list_tile.dart';
import 'widget/search_box.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  Future<void> _playMusic(BuildContext context, Music music) async {
    final audioService = context.read<AudioPlayerService>();

    await audioService.setQueue(musics: [music], initialIndex: 0);

    await audioService.play();

    if (!context.mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MusicPlayerScreen()),
    );
  }

  Future<void> _addToQueue(BuildContext context, Music music) async {
    final audioService = context.read<AudioPlayerService>();

    await audioService.addToQueue(music);
  }

  void _openGenre(BuildContext context, String genre) {
    final bloc = context.read<LibraryBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: GenreTracksScreen(genre: genre, repository: bloc.repository),
        ),
      ),
    );
  }

  void _openPlaylist(BuildContext context) {
    final bloc = context.read<LibraryBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: UserPlaylistScreen(repository: bloc.repository),
        ),
      ),
    ).then((_) {
      if (!context.mounted) {
        return;
      }

      context.read<LibraryBloc>().add(RefreshSavedMusics());
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioService = context.read<AudioPlayerService>();

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryInitial || state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LibraryError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Không thể tải thư viện',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11.sp,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    TextButton(
                      onPressed: () {
                        context.read<LibraryBloc>().add(LoadLibrary());
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! LibraryLoaded) {
            return const SizedBox();
          }

          return StreamBuilder<int?>(
            stream: audioService.currentIndexStream,
            initialData: audioService.player.currentIndex,
            builder: (context, snapshot) {
              return _buildLoaded(context, state);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, LibraryLoaded state) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28.w, 16.h, 28.w, 0),
          child: SearchBox(
            onChanged: (query) {
              context.read<LibraryBloc>().add(SearchLibrary(query));
            },
          ),
        ),

        SizedBox(height: 14.h),

        if (state.searchQuery.isNotEmpty)
          Expanded(child: _buildSearchResults(context, state))
        else
          Expanded(child: _buildMainLibrary(context, state)),
      ],
    );
  }

  // =========================================================
  // MAIN LIBRARY
  // =========================================================

  Widget _buildMainLibrary(BuildContext context, LibraryLoaded state) {
    final entries = state.genrePreviews.entries.toList();

    return ListView(
      padding: EdgeInsets.only(bottom: 24.h),
      children: [
        _buildSavedBanner(context, state),

        SizedBox(height: 26.h),

        ...entries.map((entry) {
          return _buildGenreSection(
            context,
            genre: entry.key,
            musics: entry.value,
            state: state,
          );
        }),
      ],
    );
  }

  Widget _buildSavedBanner(BuildContext context, LibraryLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Material(
        color: AppTheme.cardLightColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            _openPlaylist(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.favorite_rounded,
                    color: AppTheme.primaryColor,
                    size: 22.sp,
                  ),
                ),

                SizedBox(width: 13.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bài hát của bạn',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      Text(
                        '${state.savedTrackIds.length} bài hát',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textMuted,
                  size: 25.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreSection(
    BuildContext context, {
    required String genre,
    required List<Music> musics,
    required LibraryLoaded state,
  }) {
    final audioService = context.read<AudioPlayerService>();

    final currentMusic = audioService.currentMusic;

    return Padding(
      padding: EdgeInsets.only(bottom: 26.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    genre,
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    _openGenre(context, genre);
                  },
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              children: musics.map((music) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: MusicListTile(
                    music: music,

                    isSaved: state.savedTrackIds.contains(music.id),

                    isCurrent: currentMusic?.id == music.id,

                    onPlay: () {
                      _playMusic(context, music);
                    },

                    onSavedTap: () {
                      context.read<LibraryBloc>().add(
                        ToggleSavedMusic(music.id),
                      );
                    },

                    onAddToQueue: () {
                      _addToQueue(context, music);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SEARCH
  // =========================================================

  Widget _buildSearchResults(BuildContext context, LibraryLoaded state) {
    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.searchResults.isEmpty) {
      return Center(
        child: Text(
          'Không tìm thấy bài hát',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 14.sp),
        ),
      );
    }

    final audioService = context.read<AudioPlayerService>();

    final currentMusic = audioService.currentMusic;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(28.w, 12.h, 28.w, 24.h),
      itemCount: state.searchResults.length,
      separatorBuilder: (_, _) {
        return SizedBox(height: 12.h);
      },
      itemBuilder: (context, index) {
        final music = state.searchResults[index];

        return MusicListTile(
          music: music,

          isSaved: state.savedTrackIds.contains(music.id),

          isCurrent: currentMusic?.id == music.id,

          onPlay: () {
            _playMusic(context, music);
          },

          onSavedTap: () {
            context.read<LibraryBloc>().add(ToggleSavedMusic(music.id));
          },

          onAddToQueue: () {
            _addToQueue(context, music);
          },
        );
      },
    );
  }
}
