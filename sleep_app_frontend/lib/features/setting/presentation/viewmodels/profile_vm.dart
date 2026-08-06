import 'package:flutter/material.dart';
import '../../repository/profile_repository.dart';
import '../../data/models/user_models.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;
  ProfileViewModel(this._repository);

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _fullNameError;
  String? get fullNameError => _fullNameError;
  String? _emailError;
  String? get emailError => _emailError;
  String? _phoneNumberError;
  String? get phoneNumberError => _phoneNumberError;
  String? _sexError;
  String? get sexError => _sexError;
  String? _dateOfBirthError;
  String? get dateOfBirthError => _dateOfBirthError;
  void clearAllErrors() {
    _fullNameError = null;
    _emailError = null;
    _phoneNumberError = null;
    _sexError = null;
    _dateOfBirthError = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _repository.getUserProfile(userId);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String id,
    required String fullName,
    required String email,
    required String sex,
    required String dateOfBirth,
    required String phoneNumber,
  }) async {
    clearAllErrors();
    notifyListeners();
    bool hasValidationError = false;
    if (fullName.isEmpty) {
      _fullNameError = 'Vui lòng nhập họ và tên của bạn';
      hasValidationError = true;
    }
    if (email.isEmpty) {
      _emailError = 'Vui lòng nhập địa chỉ email';
      hasValidationError = true;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Định dạng email không hợp lệ';
      hasValidationError = true;
    }

    final phoneRegex = RegExp(r'^(0[35789])[0-9]{8}$');

    if (phoneNumber.isEmpty) {
      _phoneNumberError = 'Vui lòng nhập số điện thoại của bạn';
      hasValidationError = true;
    } else if (!phoneRegex.hasMatch(phoneNumber)) {
      _phoneNumberError = 'Số điện thoại không đúng định dạng ';
      hasValidationError = true;
    }

    if (sex.isEmpty) {
      _sexError = 'Vui lòng chọn giới tính';
      hasValidationError = true;
    }

    if (dateOfBirth.isEmpty) {
      _dateOfBirthError = 'Vui lòng chọn ngày sinh';
      hasValidationError = true;
    }
    if (hasValidationError) {
      notifyListeners();
      return false;
    }
    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = UserModel(
        id: id,
        fullName: fullName,
        email: email,
        sex: sex,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
      );

      await _repository.updateUserProfile(id, updatedUser);
      _user = updatedUser;

      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
