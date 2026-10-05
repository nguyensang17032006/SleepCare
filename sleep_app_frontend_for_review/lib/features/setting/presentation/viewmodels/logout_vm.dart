import 'package:flutter/material.dart';

import '../../repository/logout_repository.dart';

class LogoutViewModel extends ChangeNotifier {
  final LogoutRepository _logoutRepository;

  LogoutViewModel(this._logoutRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> handleLogout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _logoutRepository.logout();
      _isLoading = false;
      notifyListeners();
      return true; // Thành công
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false; // Thất bại
    }
  }
}
