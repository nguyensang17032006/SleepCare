import "dart:async";
import "package:flutter/material.dart";

class TimeRemainingViewModel extends ChangeNotifier {
  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;

  int get secondsRemaining => _secondsRemaining;
  bool get canResend => _canResend;

  void startCountdown() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _canResend = true;
        notifyListeners();
      }
    });
  }

  void resetCountdown() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _canResend = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}