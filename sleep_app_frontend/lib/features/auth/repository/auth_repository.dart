
import '../data/sources/auth_sources.dart';

class AuthRepository {
  final AuthRemoteSource _authRemoteSource;

  AuthRepository(this._authRemoteSource);

  //  đăng ký bằng email
  Future<void> registerWithEmail({
    required String fullname,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await _authRemoteSource.signUpWithEmail(
        fullname: fullname,
        username: username,
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // xác minh email
  Future<void> verifyEmail({required String email, required String otp}) async {
    try {
      await _authRemoteSource.verifyEmail(email: email, otp: otp);
    } catch (e) {
      rethrow;
    }
  }

  // đăng nhập bằng username && password
   Future<void> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      await _authRemoteSource.signInWithUsername(username: username, password: password);
    } catch (e) {
      rethrow;
    }
  }
 
  
  // đăng nhập bằng Google
  Future<void> signInWithGoogle() async {
    try {
      await _authRemoteSource.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendOTP({required String email}) async {
    try {
      await _authRemoteSource.resendOTP(email: email);
    } catch (e) {
      rethrow;
    }
  }


  Future<bool> resetPassword({required String email}) async {
    try {
      await _authRemoteSource.resetPassword(email: email);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyResetPasswordOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await _authRemoteSource.verifyResetPasswordOTP(email: email, otp: otp);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword({

    required String newPassword,
  }) async {
    try {
      await _authRemoteSource.updatePassword(newPassword: newPassword);
    } catch (e) {
      rethrow;
    }
  }
  // Kiểm tra username đã tồn tại chưa
  Future<bool> checkUsernameExists(String username) async {
    try {
      return await _authRemoteSource.isUsernameExist(username);
    } catch (_) {
      return false;
    }
  }

  // Kiểm tra email đã tồn tại chưa
  Future<bool> checkEmailExists(String email) async {
    try {
      return await _authRemoteSource.isEmailExist(email);
    } catch (_) {
      return false;
    }
  }
}
