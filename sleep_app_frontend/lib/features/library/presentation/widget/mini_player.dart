import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/audio_player_service.dart';
import '../../../../core/theme/theme.dart';
import '../player/music_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioService = context.read<AudioPlayerService>();

    return StreamBuilder<int?>(
      stream: audioService.currentIndexStream,
      initialData: audioService.player.currentIndex,
      builder: (context, indexSnapshot) {
        final music = audioService.currentMusic;

        // Chưa phát bài nào -> không hiện mini player
        if (music == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.cardLightColor,
            border: Border(
              top: BorderSide(
                color: AppTheme.primaryColor.withValues(
                  alpha: 0.15,
                ),
                width: 1,
              ),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MusicPlayerScreen(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 8.h,
                ),
                child: Row(
                  children: [
                    _buildCover(
                      music.coverUrl,
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            music.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 3.h),

                          Text(
                            _buildSubtitle(
                              music.artist,
                              music.genre,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    StreamBuilder<PlayerState>(
                      stream: audioService.playerStateStream,
                      builder: (context, stateSnapshot) {
                        final state = stateSnapshot.data;

                        final processingState =
                            state?.processingState;

                        final isLoading =
                            processingState ==
                                ProcessingState.loading ||
                            processingState ==
                                ProcessingState.buffering;

                        if (isLoading) {
                          return SizedBox(
                            width: 36.w,
                            height: 36.w,
                            child: Padding(
                              padding: EdgeInsets.all(
                                9.w,
                              ),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          );
                        }

                        final isPlaying =
                            state?.playing ?? false;

                        return IconButton(
                          onPressed: () {
                            audioService.togglePlayPause();
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 38.w,
                            minHeight: 38.w,
                          ),
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_outline_rounded
                                : Icons.play_circle_outline_rounded,
                            color: AppTheme.primaryColor,
                            size: 30.sp,
                          ),
                        );
                      },
                    ),

                    SizedBox(width: 2.w),

                    IconButton(
                      onPressed: () {
                        audioService.next();
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 36.w,
                        minHeight: 36.w,
                      ),
                      icon: Icon(
                        Icons.skip_next_rounded,
                        color: AppTheme.textLight,
                        size: 27.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCover(
    String? coverUrl,
  ) {
    if (coverUrl == null || coverUrl.isEmpty) {
      return _fallbackCover();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        8.r,
      ),
      child: Image.network(
        coverUrl,
        width: 46.w,
        height: 46.w,
        fit: BoxFit.cover,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _fallbackCover();
        },
      ),
    );
  }

  Widget _fallbackCover() {
    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: BorderRadius.circular(
          8.r,
        ),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: AppTheme.primaryColor,
        size: 22.sp,
      ),
    );
  }

  String _buildSubtitle(
    List<String>? artists,
    List<String> genres,
  ) {
    if (artists != null && artists.isNotEmpty) {
      return artists.join(', ');
    }

    if (genres.isNotEmpty) {
      return genres.join(', ');
    }

    return 'Sleep Care';
  }
}