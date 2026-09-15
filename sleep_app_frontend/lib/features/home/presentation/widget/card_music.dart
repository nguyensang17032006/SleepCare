import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/audio_player_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../library/domain/entities/music.dart';

class CardMusic extends StatelessWidget {
  const CardMusic({
    super.key,
    required this.music,
    required this.audioPlayerService,
  });

  final Music music;
  final AudioPlayerService audioPlayerService;

  Future<void> _playMusic() async {
    final currentMusic =
        audioPlayerService.currentMusic;

    final isCurrent =
        currentMusic?.id == music.id;

    if (isCurrent) {
      await audioPlayerService.togglePlayPause();
      return;
    }

    await audioPlayerService.setQueue(
      musics: [music],
      initialIndex: 0,
    );

    await audioPlayerService.playAtIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream:
          audioPlayerService.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        final isCurrent =
            audioPlayerService.currentMusic?.id ==
                music.id;

        final isPlaying =
            isCurrent && (state?.playing ?? false);

        return Container(
          height: 172.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(24.r),
            image: DecorationImage(
              image: music.coverUrl != null &&
                      music.coverUrl!.isNotEmpty
                  ? NetworkImage(
                      music.coverUrl!,
                    )
                  : const AssetImage(
                      'assets/images/forest_moon.png',
                    ) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(24.r),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(
                    alpha: 0.22,
                  ),
                  Colors.black.withValues(
                    alpha: 0.76,
                  ),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.end,
              children: [
                Text(
                  music.title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _buildSubtitle(),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white
                              .withValues(
                            alpha: 0.72,
                          ),
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _playMusic,
                      child: Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme
                                  .primaryColor
                                  .withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 14.r,
                            ),
                          ],
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons
                                  .pause_rounded
                              : Icons
                                  .play_arrow_rounded,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _buildSubtitle() {
    if (music.artist != null &&
        music.artist!.isNotEmpty) {
      return music.artist!.join(', ');
    }

    if (music.description.trim().isNotEmpty) {
      return music.description;
    }

    if (music.genre.isNotEmpty) {
      return music.genre.join(' • ');
    }

    return 'Âm thanh thư giãn';
  }
}