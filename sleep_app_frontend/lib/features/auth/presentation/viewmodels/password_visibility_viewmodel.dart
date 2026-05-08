import 'package:flutter/material.dart';

class PasswordVisibility extends ChangeNotifier {

  bool _isPasswordVisible = true;
  bool get isPasswordVisible => _isPasswordVisible;


  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners(); 
  }
}