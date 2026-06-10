import "package:flutter/material.dart";

class ForgetPasswordVM extends ChangeNotifier {
  bool _isPasswordVisible = true;

  bool get isPasswordVisible => _isPasswordVisible;
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
}
