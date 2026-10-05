import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/audio_player_service.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/music.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = context.read<AudioPlayerService>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.bgGradient,
        ),
        child: SafeArea(
          child: StreamBuilder<int?>(
            stream: audioService.currentIndexStream,
            initialData: audioService.player.currentIndex,
            builder: (context, snapshot) {
              final music = audioService.currentMusic;

              if (music == null) {
                return const Center(
                  child: Text(
                    'Không có bài hát đang phát',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                    ),
                  ),
                );
              }

              return _PlayerContent(
                music: music,
                audioService: audioService,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PlayerContent extends StatelessWidget {
  const _PlayerContent({
    required this.music,
    required this.audioService,
  });

  final Music music;
  final AudioPlayerService audioService;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;

        final horizontalPadding =
            isTablet ? 56.w : 24.w;

        final coverSize =
            isTablet ? 230.w : constraints.maxWidth * 0.48;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: _buildHeader(context),
            ),

            Expanded(
              child: Column(
                children: [
                  // =========================
                  // PLAYER PHẦN TRÊN
                  // =========================
                  SizedBox(
                    height: constraints.maxHeight * 0.53,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 6.h),

                          _buildCover(coverSize),

                          SizedBox(height: 14.h),

                          _buildMusicInfo(),

                          SizedBox(height: 8.h),

                          _buildProgress(),

                          SizedBox(height: 8.h),

                          _buildControls(),
                        ],
                      ),
                    ),
                  ),

                  // =========================
                  // QUEUE PHẦN DƯỚI
                  // =========================
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.cardLightColor
                            .withValues(alpha: 0.22),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          20.w,
                          16.h,
                          20.w,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Danh sách đang phát',
                                  style: TextStyle(
                                    color: AppTheme.textLight,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const Spacer(),

                                ValueListenableBuilder<List<Music>>(
                                  valueListenable:
                                      audioService.queueNotifier,
                                  builder: (
                                    context,
                                    queue,
                                    _,
                                  ) {
                                    return Text(
                                      '${queue.length} bài',
                                      style: TextStyle(
                                        color:
                                            AppTheme.textMuted,
                                        fontSize: 11.sp,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: 12.h),

                            Expanded(
                              child: _buildQueue(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 46.h,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textLight,
              size: 28.sp,
            ),
          ),

          PopupMenuButton<String>(
            tooltip: '',
            color: AppTheme.cardLightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            icon: Icon(
              Icons.more_vert_rounded,
              color: AppTheme.textMuted,
              size: 24.sp,
            ),
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Row(
                  children: [
                    Icon(
                      Icons.queue_music,
                      color: AppTheme.primaryColor,
                      size: 21.sp,
                    ),

                    SizedBox(width: 10.w),

                    const Text(
                      'Danh sách đang phát',
                      style: TextStyle(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCover(double size) {
    if (music.coverUrl == null ||
        music.coverUrl!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTheme.cardLightColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(
          Icons.music_note_rounded,
          color: AppTheme.primaryColor,
          size: 58.sp,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Image.network(
        music.coverUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Container(
            width: size,
            height: size,
            color: AppTheme.cardLightColor,
            child: Icon(
              Icons.music_note_rounded,
              color: AppTheme.primaryColor,
              size: 58.sp,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMusicInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            music.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            music.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return StreamBuilder<Duration?>(
      stream: audioService.durationStream,
      builder: (
        context,
        durationSnapshot,
      ) {
        final duration =
            durationSnapshot.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: audioService.positionStream,
          initialData: Duration.zero,
          builder: (
            context,
            positionSnapshot,
          ) {
            var position =
                positionSnapshot.data ?? Duration.zero;

            if (position > duration) {
              position = duration;
            }

            final maxValue =
                duration.inMilliseconds > 0
                    ? duration.inMilliseconds.toDouble()
                    : 1.0;

            final currentValue =
                position.inMilliseconds
                    .toDouble()
                    .clamp(
                      0.0,
                      maxValue,
                    );

            return Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3.h,
                    activeTrackColor:
                        AppTheme.primaryColor,
                    inactiveTrackColor:
                        AppTheme.textMuted
                            .withValues(alpha: 0.25),
                    thumbColor:
                        AppTheme.primaryColor,
                    thumbShape:
                        RoundSliderThumbShape(
                          enabledThumbRadius: 5.r,
                        ),
                  ),
                  child: Slider(
                    min: 0,
                    max: maxValue,
                    value: currentValue,
                    onChanged: (value) {
                      audioService.seek(
                        Duration(
                          milliseconds:
                              value.round(),
                        ),
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(position),
                      style: _timeStyle(),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: _timeStyle(),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
      children: [
        StreamBuilder<bool>(
          stream:
              audioService.shuffleModeEnabledStream,
          initialData:
              audioService.player.shuffleModeEnabled,
          builder: (context, snapshot) {
            final enabled =
                snapshot.data ?? false;

            return IconButton(
              onPressed:
                  audioService.toggleShuffle,
              icon: Icon(
                Icons.shuffle_rounded,
                color: enabled
                    ? AppTheme.primaryColor
                    : AppTheme.textMuted,
                size: 23.sp,
              ),
            );
          },
        ),

        IconButton(
          onPressed: audioService.previous,
          icon: Icon(
            Icons.skip_previous_rounded,
            color: AppTheme.textLight,
            size: 30.sp,
          ),
        ),

        StreamBuilder<PlayerState>(
          stream:
              audioService.playerStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;

            final loading =
                state?.processingState ==
                    ProcessingState.loading ||
                state?.processingState ==
                    ProcessingState.buffering;

            if (loading) {
              return SizedBox(
                width: 58.w,
                height: 58.w,
                child:
                    const CircularProgressIndicator(
                  color:
                      AppTheme.primaryColor,
                ),
              );
            }

            final playing =
                state?.playing ?? false;

            return InkWell(
              borderRadius:
                  BorderRadius.circular(100.r),
              onTap:
                  audioService.togglePlayPause,
              child: Container(
                width: 58.w,
                height: 58.w,
                decoration:
                    const BoxDecoration(
                  color:
                      AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  playing
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: AppTheme.textLight,
                  size: 34.sp,
                ),
              ),
            );
          },
        ),

        IconButton(
          onPressed: audioService.next,
          icon: Icon(
            Icons.skip_next_rounded,
            color: AppTheme.textLight,
            size: 30.sp,
          ),
        ),

        StreamBuilder<LoopMode>(
          stream:
              audioService.loopModeStream,
          initialData:
              audioService.player.loopMode,
          builder: (context, snapshot) {
            final loopMode =
                snapshot.data ?? LoopMode.off;

            return IconButton(
              onPressed:
                  audioService.changeLoopMode,
              icon: Icon(
                loopMode == LoopMode.one
                    ? Icons.repeat_one_rounded
                    : Icons.repeat_rounded,
                color:
                    loopMode == LoopMode.off
                        ? AppTheme.textMuted
                        : AppTheme.primaryColor,
                size: 23.sp,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQueue() {
    return ValueListenableBuilder<List<Music>>(
      valueListenable:
          audioService.queueNotifier,
      builder: (
        context,
        queue,
        _,
      ) {
        if (queue.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có bài hát',
              style: TextStyle(
                color: AppTheme.textMuted,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(
            bottom: 16.h,
          ),
          itemCount: queue.length,
          separatorBuilder: (_, _) {
            return SizedBox(
              height: 6.h,
            );
          },
          itemBuilder: (
            context,
            index,
          ) {
            final item = queue[index];

            return StreamBuilder<int?>(
              stream:
                  audioService.currentIndexStream,
              initialData:
                  audioService.player.currentIndex,
              builder: (
                context,
                snapshot,
              ) {
                final isCurrent =
                    snapshot.data == index;

                return Slidable(
                  key: ValueKey(
                    'queue-${item.id}',
                  ),

                  // Vuốt sang trái
                  endActionPane: ActionPane(
                    motion:
                        const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          await audioService
                              .removeFromQueueAt(
                            index,
                          );
                        },
                        backgroundColor:
                            Colors.redAccent,
                        foregroundColor:
                            Colors.white,
                        icon:
                            Icons.delete_outline_rounded,
                        label: 'Xóa',
                        borderRadius:
                            BorderRadius.circular(
                          12.r,
                        ),
                      ),
                    ],
                  ),

                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(
                      12.r,
                    ),
                    onTap: () {
                      audioService.playAtIndex(
                        index,
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 8.w,
                      ),
                      decoration:
                          BoxDecoration(
                        color: isCurrent
                            ? AppTheme
                                .primaryColor
                                .withValues(
                                  alpha: 0.12,
                                )
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(
                          12.r,
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildQueueCover(
                            item,
                          ),

                          SizedBox(
                            width: 12.w,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      TextStyle(
                                    color: isCurrent
                                        ? AppTheme
                                            .primaryColor
                                        : AppTheme
                                            .textLight,
                                    fontSize:
                                        13.sp,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                SizedBox(
                                  height: 3.h,
                                ),

                                Text(
                                  item.artist !=
                                              null &&
                                          item
                                              .artist!
                                              .isNotEmpty
                                      ? item
                                          .artist!
                                          .join(
                                            ', ',
                                          )
                                      : item.genre
                                          .join(
                                            ', ',
                                          ),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      TextStyle(
                                    color:
                                        AppTheme
                                            .textMuted,
                                    fontSize:
                                        10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (isCurrent)
                            Icon(
                              Icons
                                  .graphic_eq_rounded,
                              color:
                                  AppTheme
                                      .primaryColor,
                              size: 20.sp,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQueueCover(
    Music music,
  ) {
    if (music.coverUrl == null ||
        music.coverUrl!.isEmpty) {
      return Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: AppTheme.cardLightColor,
          borderRadius:
              BorderRadius.circular(9.r),
        ),
        child: Icon(
          Icons.music_note,
          color: AppTheme.primaryColor,
          size: 19.sp,
        ),
      );
    }

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(9.r),
      child: Image.network(
        music.coverUrl!,
        width: 42.w,
        height: 42.w,
        fit: BoxFit.cover,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Container(
            width: 42.w,
            height: 42.w,
            color:
                AppTheme.cardLightColor,
            child: Icon(
              Icons.music_note,
              color:
                  AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  TextStyle _timeStyle() {
    return TextStyle(
      color: AppTheme.textMuted,
      fontSize: 10.sp,
    );
  }

  String _formatDuration(
    Duration duration,
  ) {
    final minutes =
        duration.inMinutes;

    final seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }
}