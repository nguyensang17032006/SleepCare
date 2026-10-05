import '../data/sources/auth_sources.dart';

class AuthRepository {
  final AuthRemoteSource _authRemoteSource;

  AuthRepository(this._authRemoteSource);

  Future<void> registerWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      await _authRemoteSource.signUpWithEmail(
        fullname: fullname,
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      await _authRemoteSource.verifyEmail(
        email: email,
        otp: otp,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _authRemoteSource.signInWithEmail(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authRemoteSource.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendOTP({
    required String email,
  }) async {
    try {
      await _authRemoteSource.resendOTP(
        email: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPassword({
    required String email,
  }) async {
    try {
      await _authRemoteSource.resetPassword(
        email: email,
      );

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
      await _authRemoteSource.verifyResetPasswordOTP(
        email: email,
        otp: otp,
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      await _authRemoteSource.updatePassword(
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authRemoteSource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUsernameExists(
    String username,
  ) async {
    try {
      return await _authRemoteSource
          .isUsernameExist(username);
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkEmailExists(
    String email,
  ) async {
    try {
      return await _authRemoteSource
          .isEmailExist(email);
    } catch (_) {
      return false;
    }
  }
}