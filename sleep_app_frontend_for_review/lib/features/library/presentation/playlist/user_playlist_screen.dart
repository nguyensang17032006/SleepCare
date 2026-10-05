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

class UserPlaylistScreen extends StatefulWidget {
  const UserPlaylistScreen({
    super.key,
    required this.repository,
  });

  final LibraryRepository repository;

  @override
  State<UserPlaylistScreen> createState() =>
      _UserPlaylistScreenState();
}

class _UserPlaylistScreenState
    extends State<UserPlaylistScreen> {
  bool _loading = true;

  List<Music> _musics = [];

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<void> _load() async {
    try {
      final musics =
          await widget.repository.getSavedMusics();

      if (!mounted) return;

      setState(() {
        _musics = musics;
        _loading = false;
      });
    } catch (e) {
      debugPrint(
        'LOAD SAVED MUSICS ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _play(
    int index,
  ) async {
    if (_musics.isEmpty) {
      return;
    }

    final audioService =
        context.read<AudioPlayerService>();

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
        context.read<AudioPlayerService>();

    await audioService.addToQueue(
      music,
    );
  }

  void _remove(
    Music music,
  ) {
    context.read<LibraryBloc>().add(
      ToggleSavedMusic(
        music.id,
      ),
    );

    setState(() {
      _musics.removeWhere(
        (item) =>
            item.id == music.id,
      );
    });
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
        title: const Text(
          'Bài hát của bạn',
          style: TextStyle(
            color:
                AppTheme.textLight,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_musics.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .favorite_border_rounded,
              color:
                  AppTheme.textMuted,
              size: 54.sp,
            ),

            SizedBox(
              height: 12.h,
            ),

            Text(
              'Chưa có bài hát đã lưu',
              style: TextStyle(
                color:
                    AppTheme.textMuted,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    }

    final audioService =
        context.read<AudioPlayerService>();

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.fromLTRB(
            24.w,
            14.h,
            24.w,
            8.h,
          ),
          child: Row(
            children: [
              Text(
                '${_musics.length} bài hát',
                style: TextStyle(
                  color:
                      AppTheme.textMuted,
                  fontSize: 13.sp,
                ),
              ),

              const Spacer(),

              FilledButton.icon(
                onPressed: () {
                  _play(0);
                },
                icon: const Icon(
                  Icons
                      .play_arrow_rounded,
                ),
                label:
                    const Text(
                  'Phát tất cả',
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: BlocBuilder<
              LibraryBloc,
              LibraryState>(
            builder:
                (context, state) {
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

                  return ListView
                      .separated(
                    padding:
                        EdgeInsets
                            .fromLTRB(
                      24.w,
                      12.h,
                      24.w,
                      24.h,
                    ),
                    itemCount:
                        _musics.length,
                    separatorBuilder:
                        (_, _) {
                      return SizedBox(
                        height: 12.h,
                      );
                    },
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
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
                          _play(
                            index,
                          );
                        },

                        onSavedTap:
                            () {
                          _remove(
                            music,
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
          ),
        ),
      ],
    );
  }
}