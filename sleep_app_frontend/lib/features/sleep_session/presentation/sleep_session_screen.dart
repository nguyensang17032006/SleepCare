import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import '../data/sources/session_source.dart';

class SleepSessionScreen extends StatefulWidget {
  final String musicUrl;
  final String musicName;
  final int durationMinutes;

  const SleepSessionScreen({
    super.key,
    required this.musicUrl,
    required this.musicName,
    required this.durationMinutes,
  });

  @override
  State<SleepSessionScreen> createState() => _SleepSessionScreenState();
}

class _SleepSessionScreenState extends State<SleepSessionScreen> {
  late AudioPlayer _audioPlayer;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isPlaying = true;
  bool _isFinished = false;

  final SessionSource _sessionSource = SessionSource();
  String? _sessionId;
  int _initialSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
    _initialSeconds = _remainingSeconds;
    _startSessionLog();
    _initAudio();
    _startTimer();
  }

  Future<void> _startSessionLog() async {
    _sessionId = await _sessionSource.startBedtimeSession();
  }

  Future<void> _initAudio() async {
    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.musicUrl),
          tag: MediaItem(
            id: widget.musicUrl,
            title: widget.musicName,
            artist: "SleepCare",
          ),
        ),
      );
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Error loading audio: \$e");
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _finishSession();
      }
    });
  }

  Future<void> _finishSession() async {
    _timer?.cancel();
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isFinished = true;
      });
    }
    
    if (_sessionId != null) {
      await _sessionSource.endBedtimeSession(_sessionId!);
      int listened = _initialSeconds - _remainingSeconds;
      if (listened > 0) {
        await _sessionSource.logListeningSession(
          bedtimeSessionId: _sessionId!,
          musicUrl: widget.musicUrl,
          listenedSeconds: listened,
        );
      }
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    if (!_isFinished && _sessionId != null) {
      // If user quits early, we end it now
      _sessionSource.endBedtimeSession(_sessionId!);
      int listened = _initialSeconds - _remainingSeconds;
      if (listened > 0) {
        _sessionSource.logListeningSession(
          bedtimeSessionId: _sessionId!,
          musicUrl: widget.musicUrl,
          listenedSeconds: listened,
        );
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A pitch black screen for sleeping
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                _isFinished ? Icons.wb_sunny : Icons.nightlight_round,
                color: _isFinished
                    ? Colors.amber
                    : AppTheme.primaryColor.withValues(alpha: 0.5),
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                _isFinished
                    ? "Chào buổi sáng!"
                    : _formatTime(_remainingSeconds),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              if (!_isFinished)
                Text(
                  'Đang phát: \${widget.musicName}',
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              if (!_isFinished) const SizedBox(height: 8),
              if (!_isFinished)
                const Text(
                  'Bạn có thể khóa màn hình, nhạc sẽ tự tắt khi hết giờ.',
                  style: TextStyle(color: Colors.white30, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              const Spacer(),
              if (!_isFinished)
                IconButton(
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioPlayer.pause();
                    } else {
                      await _audioPlayer.play();
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 64,
                    color: Colors.white54,
                  ),
                ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white54,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(_isFinished ? 'Quay lại' : 'Thoát'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
