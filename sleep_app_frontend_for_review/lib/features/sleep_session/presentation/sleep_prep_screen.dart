import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/features/library/domain/entities/music.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepPrep/sleep_prep_bloc.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepPrep/sleep_prep_event.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepPrep/sleep_prep_state.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/sleep_session_screen.dart';

class SleepPrepScreen extends StatefulWidget {
  final VoidCallback onOpenLibrary;

  const SleepPrepScreen({super.key, required this.onOpenLibrary});

  @override
  State<SleepPrepScreen> createState() => _SleepPrepScreenState();
}

class _SleepPrepScreenState extends State<SleepPrepScreen> {
  final List<int> _durationOptions = [30, 45, 60, 90];

  @override
  void initState() {
    super.initState();

    context.read<SleepPrepBloc>().add(const SleepPrepStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: BlocBuilder<SleepPrepBloc, SleepPrepState>(
        builder: (context, state) {
          if (state is SleepPrepInitial || state is SleepPrepLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is SleepPrepFailure) {
            return _buildFailure(state);
          }

          if (state is SleepPrepEmpty) {
            return _buildEmpty();
          }

          if (state is SleepPrepLoaded) {
            return _buildLoaded(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.library_music_outlined,
              color: AppTheme.primaryColor,
              size: 72,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bạn chưa lưu bài nhạc nào',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy khám phá thư viện và lưu những bài nhạc bạn muốn nghe khi ngủ.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Khám phá thư viện',
              onPressed: widget.onOpenLibrary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailure(SleepPrepFailure state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<SleepPrepBloc>().add(const SleepPrepStarted());
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(SleepPrepLoaded state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhạc đã lưu',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Chọn một bài để nghe khi ngủ',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              itemCount: state.savedMusics.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final music = state.savedMusics[index];

                return _buildMusicCard(
                  music: music,
                  isSelected: music.id == state.selectedMusic.id,
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          InkWell(
            onTap: () => _showDurationPicker(state.durationMinutes),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardLightColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Thời gian phát nhạc',
                      style: TextStyle(color: AppTheme.textLight, fontSize: 15),
                    ),
                  ),
                  Text(
                    '${state.durationMinutes} phút',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: PrimaryButton(
              text: 'Bắt đầu ngủ',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SleepSessionScreen(
                      musicUrl: state.selectedMusic.audioUrl,
                      musicName: state.selectedMusic.title,
                      durationMinutes: state.durationMinutes,
                      trackId: state.selectedMusic.id,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicCard({required Music music, required bool isSelected}) {
    final artist = music.artist?.join(', ');

    return InkWell(
      onTap: () {
        context.read<SleepPrepBloc>().add(SleepPrepTrackSelected(music));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.18)
              : AppTheme.cardLightColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 58,
                height: 58,
                child: music.coverUrl != null && music.coverUrl!.isNotEmpty
                    ? Image.network(
                        music.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return _buildDefaultCover();
                        },
                      )
                    : _buildDefaultCover(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (artist != null && artist.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      color: AppTheme.cardColor,
      child: const Icon(Icons.music_note, color: AppTheme.primaryColor),
    );
  }

  void _showDurationPicker(int currentDuration) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _durationOptions.map((minutes) {
              return ChoiceChip(
                label: Text('$minutes phút'),
                selected: minutes == currentDuration,
                onSelected: (_) {
                  context.read<SleepPrepBloc>().add(
                    SleepPrepDurationChanged(minutes),
                  );

                  Navigator.pop(bottomSheetContext);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
