import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../features/library/domain/entities/music.dart';

class AudioPlayerService {
  AudioPlayerService();

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  // =========================================================
  // QUEUE
  // =========================================================

  List<Music> _queue = [];

  List<Music> get queue => List.unmodifiable(_queue);

  /// Cho UI lắng nghe khi queue thay đổi:
  /// add / remove / setQueue
  final ValueNotifier<List<Music>> queueNotifier =
      ValueNotifier<List<Music>>([]);

  void _notifyQueueChanged() {
    queueNotifier.value = List<Music>.from(_queue);
  }

  Music? get currentMusic {
    final index = _player.currentIndex;

    if (index == null ||
        index < 0 ||
        index >= _queue.length) {
      return null;
    }

    return _queue[index];
  }

  // =========================================================
  // STREAM
  // =========================================================

  Stream<PlayerState> get playerStateStream =>
      _player.playerStateStream;

  Stream<Duration> get positionStream =>
      _player.positionStream;

  Stream<Duration?> get durationStream =>
      _player.durationStream;

  Stream<int?> get currentIndexStream =>
      _player.currentIndexStream;

  Stream<LoopMode> get loopModeStream =>
      _player.loopModeStream;

  Stream<bool> get shuffleModeEnabledStream =>
      _player.shuffleModeEnabledStream;

  // =========================================================
  // CREATE AUDIO SOURCE
  // =========================================================

  AudioSource _createAudioSource(Music music) {
    return AudioSource.uri(
      Uri.parse(music.audioUrl),
      tag: MediaItem(
        id: music.id,
        title: music.title,
        artist: music.artist?.join(', '),
        artUri:
            music.coverUrl != null &&
                music.coverUrl!.isNotEmpty
            ? Uri.tryParse(music.coverUrl!)
            : null,
      ),
    );
  }

  // =========================================================
  // SET QUEUE
  // =========================================================

  Future<void> setQueue({
    required List<Music> musics,
    required int initialIndex,
  }) async {
    if (musics.isEmpty) {
      return;
    }

    if (initialIndex < 0 ||
        initialIndex >= musics.length) {
      return;
    }

    _queue = List<Music>.from(musics);

    _notifyQueueChanged();

    debugPrint('===== AUDIO QUEUE =====');
    debugPrint('Initial index: $initialIndex');
    debugPrint('Title: ${musics[initialIndex].title}');
    debugPrint('URL: ${musics[initialIndex].audioUrl}');

    final sources = musics
        .map(_createAudioSource)
        .toList();

    try {
      await _player.setAudioSources(
        sources,
        initialIndex: initialIndex,
        initialPosition: Duration.zero,
      );

      debugPrint(
        'Audio source loaded successfully',
      );
    } on PlayerInterruptedException catch (e) {
      debugPrint(
        'PLAYER INTERRUPTED: ${e.message}',
      );

      rethrow;
    } on PlayerException catch (e) {
      debugPrint(
        'PLAYER ERROR: ${e.code}',
      );

      debugPrint(
        'PLAYER ERROR MESSAGE: ${e.message}',
      );

      rethrow;
    } catch (e) {
      debugPrint(
        'UNKNOWN AUDIO ERROR: $e',
      );

      rethrow;
    }
  }

  // =========================================================
  // ADD TO CURRENT QUEUE
  // =========================================================

  Future<void> addToQueue(Music music) async {
    final alreadyExists = _queue.any(
      (item) => item.id == music.id,
    );

    if (alreadyExists) {
      debugPrint(
        'Track already exists in queue: ${music.title}',
      );

      return;
    }

    final source = _createAudioSource(music);

    try {
      await _player.addAudioSource(source);

      _queue.add(music);

      _notifyQueueChanged();

      debugPrint(
        'Added to queue: ${music.title}',
      );
    } catch (e) {
      debugPrint(
        'ADD TO QUEUE ERROR: $e',
      );

      rethrow;
    }
  }

  // =========================================================
  // REMOVE FROM CURRENT QUEUE
  // =========================================================

  Future<void> removeFromQueue(
    Music music,
  ) async {
    final index = _queue.indexWhere(
      (item) => item.id == music.id,
    );

    if (index == -1) {
      return;
    }

    await removeFromQueueAt(index);
  }

  Future<void> removeFromQueueAt(
    int index,
  ) async {
    if (index < 0 ||
        index >= _queue.length) {
      return;
    }

    final removedMusic = _queue[index];

    try {
      await _player.removeAudioSourceAt(index);

      _queue.removeAt(index);

      _notifyQueueChanged();

      debugPrint(
        'Removed from queue: ${removedMusic.title}',
      );
    } catch (e) {
      debugPrint(
        'REMOVE FROM QUEUE ERROR: $e',
      );

      rethrow;
    }
  }

  // =========================================================
  // PLAY AT INDEX
  // =========================================================

  Future<void> playAtIndex(
    int index,
  ) async {
    if (index < 0 ||
        index >= _queue.length) {
      return;
    }

    await _player.seek(
      Duration.zero,
      index: index,
    );

    await _player.play();
  }

  // =========================================================
  // PLAY / PAUSE
  // =========================================================

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  // =========================================================
  // SEEK
  // =========================================================

  Future<void> seek(
    Duration position,
  ) async {
    await _player.seek(position);
  }

  // =========================================================
  // PREVIOUS / NEXT
  // =========================================================

  Future<void> previous() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
    }
  }

  Future<void> next() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    }
  }

  // =========================================================
  // SHUFFLE
  // =========================================================

  Future<void> toggleShuffle() async {
    final enabled =
        !_player.shuffleModeEnabled;

    if (enabled) {
      await _player.shuffle();
    }

    await _player.setShuffleModeEnabled(
      enabled,
    );
  }

  // =========================================================
  // LOOP MODE
  // =========================================================

  Future<void> changeLoopMode() async {
    switch (_player.loopMode) {
      case LoopMode.off:
        await _player.setLoopMode(
          LoopMode.all,
        );
        break;

      case LoopMode.all:
        await _player.setLoopMode(
          LoopMode.one,
        );
        break;

      case LoopMode.one:
        await _player.setLoopMode(
          LoopMode.off,
        );
        break;
    }
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  Future<void> dispose() async {
    queueNotifier.dispose();

    await _player.dispose();
  }
}