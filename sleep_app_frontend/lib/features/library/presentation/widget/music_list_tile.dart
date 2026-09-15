import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/entities/music.dart';

class MusicListTile extends StatelessWidget {
  const MusicListTile({
    super.key,
    required this.music,
    required this.isSaved,
    required this.isCurrent,
    required this.onPlay,
    required this.onSavedTap,
    this.onAddToQueue,
  });

  final Music music;
  final bool isSaved;

  /// Bài hiện tại đang được chọn trong AudioPlayer
  final bool isCurrent;

  final VoidCallback onPlay;

  /// Thêm/xóa khỏi playlist cá nhân
  final VoidCallback onSavedTap;

  /// Thêm bài vào danh sách đang phát
  final VoidCallback? onAddToQueue;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      if (music.genre.isNotEmpty) music.genre.first,
      if (music.sleepStage != null && music.sleepStage!.trim().isNotEmpty)
        music.sleepStage!,
    ];

    return Row(
      children: [
        // =========================
        // COVER
        // =========================
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 58,
            height: 58,
            child: music.coverUrl != null && music.coverUrl!.trim().isNotEmpty
                ? Image.network(
                    music.coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),
        ),

        const SizedBox(width: 12),

        // =========================
        // TITLE
        // =========================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                music.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isCurrent ? AppTheme.primaryColor : AppTheme.textLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitleParts.join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),

        const SizedBox(width: 6),

        // =========================
        // PLAY / CURRENT MUSIC
        // =========================
        SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: isCurrent
                ? Icon(
                    Icons.graphic_eq_rounded,
                    color: AppTheme.primaryColor,
                    size: 28,
                  )
                : IconButton(
                    onPressed: onPlay,
                    icon: const Icon(
                      Icons.play_circle_fill_rounded,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
          ),
        ),

        // =========================
        // 3 DOT MENU
        // =========================
        PopupMenuButton<String>(
          tooltip: 'Tùy chọn',
          color: AppTheme.cardColor,
          icon: const Icon(
            Icons.more_vert_rounded,
            color: AppTheme.textMuted,
            size: 26,
          ),
          onSelected: (value) {
            switch (value) {
              case 'playlist':
                onSavedTap();
                break;

              case 'queue':
                onAddToQueue?.call();
                break;
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem<String>(
                value: 'playlist',
                child: Row(
                  children: [
                    Icon(
                      isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: AppTheme.primaryColor,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        isSaved
                            ? 'Xóa khỏi danh sách phát'
                            : 'Thêm vào danh sách phát',
                        style: const TextStyle(color: AppTheme.textLight),
                      ),
                    ),
                  ],
                ),
              ),

              const PopupMenuDivider(),

              PopupMenuItem<String>(
                value: 'queue',
                enabled: onAddToQueue != null,
                child: const Row(
                  children: [
                    Icon(
                      Icons.queue_music_rounded,
                      color: AppTheme.primaryColor,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Thêm vào danh sách đang phát',
                        style: TextStyle(color: AppTheme.textLight),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.cardColor,
      alignment: Alignment.center,
      child: const Icon(Icons.music_note_rounded, color: AppTheme.primaryColor),
    );
  }
}
