import "package:flutter/material.dart";

class CheckboxPrivacy extends ChangeNotifier{
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  void toggleCheckbox() {
    _isChecked = !_isChecked;
    notifyListeners(); 
  }
}