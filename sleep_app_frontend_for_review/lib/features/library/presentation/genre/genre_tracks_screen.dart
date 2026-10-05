import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/audio_player_service.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/music.dart';
import '../../domain/repositories/library_repository.dart';
import '../bloc/library_bloc.dart';
import '../bloc/library_event.dart';
import '../bloc/library_state.dart';
import '../player/music_player_screen.dart';
import '../widget/music_list_tile.dart';

class GenreTracksScreen
    extends StatefulWidget {
  const GenreTracksScreen({
    super.key,
    required this.genre,
    required this.repository,
  });

  final String genre;

  final LibraryRepository
      repository;

  @override
  State<GenreTracksScreen>
      createState() =>
          _GenreTracksScreenState();
}

class _GenreTracksScreenState
    extends State<GenreTracksScreen> {
  static const int _pageSize =
      20;

  final ScrollController
      _scrollController =
      ScrollController();

  final List<Music> _musics =
      [];

  int _page = 0;

  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  String? _error;

  @override
  void initState() {
    super.initState();

    _loadInitial();

    _scrollController
        .addListener(
      _onScroll,
    );
  }

  Future<void>
      _loadInitial() async {
    try {
      final musics =
          await widget.repository
              .getMusicsByGenre(
        genre: widget.genre,
        page: 0,
        limit: _pageSize,
      );

      if (!mounted) return;

      setState(() {
        _musics
          ..clear()
          ..addAll(musics);

        _page = 0;

        _hasMore =
            musics.length ==
                _pageSize;

        _isInitialLoading =
            false;

        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isInitialLoading =
            false;

        _error =
            e.toString();
      });
    }
  }

  void _onScroll() {
    if (!_scrollController
        .hasClients) {
      return;
    }

    if (_scrollController
            .position
            .extentAfter <
        250) {
      _loadMore();
    }
  }

  Future<void>
      _loadMore() async {
    if (_isLoadingMore ||
        !_hasMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage =
          _page + 1;

      final musics =
          await widget.repository
              .getMusicsByGenre(
        genre: widget.genre,
        page: nextPage,
        limit: _pageSize,
      );

      if (!mounted) return;

      setState(() {
        _musics.addAll(
          musics,
        );

        _page = nextPage;

        _hasMore =
            musics.length ==
                _pageSize;

        _isLoadingMore =
            false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingMore =
            false;
      });
    }
  }

  Future<void> _playMusic(
    int index,
  ) async {
    final audioService =
        context.read<
            AudioPlayerService>();

    await audioService.setQueue(
      musics: _musics,
      initialIndex: index,
    );

    await audioService.play();

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const MusicPlayerScreen(),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _addToQueue(
    Music music,
  ) async {
    final audioService =
        context.read<
            AudioPlayerService>();

    await audioService
        .addToQueue(
      music,
    );
  }

  @override
  void dispose() {
    _scrollController
        .removeListener(
      _onScroll,
    );

    _scrollController
        .dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor:
            AppTheme.bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color:
                AppTheme.textLight,
          ),
        ),
        title: Text(
          widget.genre,
          style:
              const TextStyle(
            color:
                AppTheme.textLight,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitialLoading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Text(
              'Không thể tải bài hát',
              style: TextStyle(
                color:
                    AppTheme.textMuted,
              ),
            ),

            SizedBox(
              height: 12.h,
            ),

            TextButton(
              onPressed:
                  _loadInitial,
              child:
                  const Text(
                'Thử lại',
              ),
            ),
          ],
        ),
      );
    }

    if (_musics.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có bài hát',
          style: TextStyle(
            color:
                AppTheme.textMuted,
          ),
        ),
      );
    }

    final audioService =
        context.read<
            AudioPlayerService>();

    return BlocBuilder<
        LibraryBloc,
        LibraryState>(
      builder: (
        context,
        state,
      ) {
        final savedIds =
            state is LibraryLoaded
                ? state
                    .savedTrackIds
                : <String>{};

        return StreamBuilder<
            int?>(
          stream:
              audioService
                  .currentIndexStream,
          initialData:
              audioService
                  .player
                  .currentIndex,
          builder: (
            context,
            currentSnapshot,
          ) {
            final currentMusic =
                audioService
                    .currentMusic;

            return ListView.separated(
              controller:
                  _scrollController,
              padding:
                  EdgeInsets
                      .fromLTRB(
                24.w,
                16.h,
                24.w,
                24.h,
              ),
              itemCount:
                  _musics.length +
                      (_isLoadingMore
                          ? 1
                          : 0),
              separatorBuilder:
                  (_, _) {
                return SizedBox(
                  height: 12.h,
                );
              },
              itemBuilder: (
                context,
                index,
              ) {
                if (index >=
                    _musics
                        .length) {
                  return Padding(
                    padding:
                        EdgeInsets.all(
                      16.h,
                    ),
                    child:
                        const Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  );
                }

                final music =
                    _musics[
                        index];

                return MusicListTile(
                  music: music,

                  isSaved:
                      savedIds
                          .contains(
                    music.id,
                  ),

                  // BÀI ĐANG PHÁT
                  isCurrent:
                      currentMusic
                              ?.id ==
                          music.id,

                  onPlay: () {
                    _playMusic(
                      index,
                    );
                  },

                  onSavedTap:
                      () {
                    context
                        .read<
                            LibraryBloc>()
                        .add(
                          ToggleSavedMusic(
                            music.id,
                          ),
                        );
                  },

                  onAddToQueue:
                      () {
                    _addToQueue(
                      music,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}