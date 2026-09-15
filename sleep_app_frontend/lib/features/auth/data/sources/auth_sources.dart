import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../main.dart';

class AuthRemoteSource {
  // Đăng ký bằng Email & Password
  Future<AuthResponse> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      return await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullname,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Đăng nhập bằng Email & Password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient
          .from('profile_sleep_app')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      if (response == null || response['email'] == null) {
        throw AuthApiException(
          'Tên đăng nhập hoặc mật khẩu không chính xác.',
          statusCode: '404',
        );
      }

      final String realEmail = response['email'];

      await supabaseClient.auth.signInWithPassword(
        email: realEmail,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Xác minh OTP đăng ký
  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      await supabaseClient.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.signup,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Đăng nhập bằng Google
  Future<void> signInWithGoogle() async {
    try {
      await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Gửi lại OTP đăng ký
  Future<void> resendOTP({
    required String email,
  }) async {
    try {
      await supabaseClient.auth.resend(
        email: email,
        type: OtpType.signup,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Gửi OTP reset password
  Future<bool> resetPassword({
    required String email,
  }) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email,
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Xác minh OTP recovery
  Future<bool> verifyResetPasswordOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await supabaseClient.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.recovery,
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Cập nhật mật khẩu
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout local/session
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Kiểm tra username tồn tại
  Future<bool> isUsernameExist(
    String username,
  ) async {
    final response = await supabaseClient
        .from('profile_sleep_app')
        .select('username')
        .eq('username', username)
        .maybeSingle();

    return response != null;
  }

  // Kiểm tra email tồn tại
  Future<bool> isEmailExist(
    String email,
  ) async {
    final response = await supabaseClient
        .from('profile_sleep_app')
        .select('email')
        .eq('email', email)
        .maybeSingle();

    return response != null;
  }
}