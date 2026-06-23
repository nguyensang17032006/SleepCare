import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _fullNameError;
  String? get fullNameError => _fullNameError;

  String? _usernameError;
  String? get usernameError => _usernameError;

  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  String? _confirmPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  void clearAllErrors() {
    _fullNameError = null;
    _usernameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isTermsChecked,
  }) async {
    clearAllErrors();
    notifyListeners();
    bool hasValidationError = false;
    if (fullname.isEmpty) {
      _fullNameError = 'Vui lòng nhập họ và tên của bạn';
      hasValidationError = true;
    }

    if (username.isEmpty) {
      _usernameError = 'Vui lòng nhập tên tài khoản';
      hasValidationError = true;
    }

    if (email.isEmpty) {
      _emailError = 'Vui lòng nhập địa chỉ email';
      hasValidationError = true;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Định dạng email không hợp lệ';
      hasValidationError = true;
    }

    if (password.isEmpty) {
      _passwordError = 'Vui lòng nhập mật khẩu';
      hasValidationError = true;
    } else if (password.length < 6) {
      _passwordError = 'Mật khẩu phải chứa ít nhất 6 ký tự';
      hasValidationError = true;
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Vui lòng xác nhận lại mật khẩu';
      hasValidationError = true;
    }
    if (!hasValidationError && password != confirmPassword) {
      _confirmPasswordError = 'Mật khẩu xác nhận không trùng khớp';
      hasValidationError = true;
    }
    if (!hasValidationError && !isTermsChecked) {
      _errorMessage = 'Bạn phải đồng ý với Điều khoản dịch vụ';
      hasValidationError = true;
    }

    if (hasValidationError) {
      notifyListeners();
      return false;
    }

    // bật loading, kiểm tra trùng dữ liệu
    _isLoading = true;
    notifyListeners();

    try {
      // Kiểm tra username đã tồn tại trong bảng profile chưa

      final isUsernameTaken = await _authRepository.checkUsernameExists(
        username,
      );
      if (isUsernameTaken) {
        _usernameError = 'Tên tài khoản này đã được sử dụng';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Kiểm tra email đã tồn tại chưa
      final isEmailTaken = await _authRepository.checkEmailExists(email);
      if (isEmailTaken) {
        _emailError = 'Địa chỉ email này đã được sử dụng';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // đăng ký với email

      await _authRepository.registerWithEmail(
        fullname: fullname,
        username: username,
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //xác thực email vừa tạo
  Future<bool> verifyEmail({
    required String email,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.verifyEmail(email: email, otp: token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ("Sai mã xác minh hoặc mã đã hết hạn. Vui lòng thử lại.");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // gửi lại mã otp
  Future<void> resendOTP({required String email}) async {
    try {
      await _authRepository.resendOTP(email: email);
    } catch (e) {
      throw Exception('Gửi lại mã OTP thất bại: $e');
    }
  }

  // đăng nhập bằng username && password
  Future<bool> signInWithUsername({
    required String username,
    required String password,
  }) async {
    bool hasValidationError = false;
    clearAllErrors();

    if (username.isEmpty) {
      _usernameError = 'Vui lòng nhập tên tài khoản';
      hasValidationError = true;
    }
    if (password.isEmpty) {
      _passwordError = 'Vui lòng nhập mật khẩu';
      hasValidationError = true;
    }

    if (hasValidationError) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signInWithUsername(
        username: username,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthApiException catch (e) {
      _isLoading = false;

      if (e.code == 'invalid_credentials') {
        _errorMessage = 'Tên tài khoản hoặc mật khẩu không chính xác';
      } else {
        _errorMessage = e.message;
      }

      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // đăng nhập bằng Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.signInWithGoogle();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authRepository.resetPassword(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Reset mật khẩu thất bại: $e');
    }
  }

  Future<bool> verifyResetPasswordOTP({
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.verifyResetPasswordOTP(email: email, otp: otp);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ("Sai mã xác minh hoặc mã đã hết hạn. Vui lòng thử lại.");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    bool hasValidationError = false;
    clearAllErrors();

    if (newPassword.isEmpty) {
      _passwordError = 'Vui lòng nhập mật khẩu mới';
      hasValidationError = true;
    } else if (newPassword.length < 6) {
      _passwordError = 'Mật khẩu phải chứa ít nhất 6 ký tự';
      hasValidationError = true;
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Vui lòng xác nhận lại mật khẩu mới';
      hasValidationError = true;
    }

    if (!hasValidationError && newPassword != confirmPassword) {
      _confirmPasswordError = 'Mật khẩu xác nhận không trùng khớp';
      hasValidationError = true;
    }

    // Nếu có lỗi validate, dừng lại và thông báo UI
    if (hasValidationError) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.updatePassword(newPassword: newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
