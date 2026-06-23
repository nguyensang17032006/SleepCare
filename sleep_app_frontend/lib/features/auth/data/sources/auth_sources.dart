import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../main.dart';

class AuthRemoteSource {
  // Hàm đăng ký bằng Email & Password
  Future<AuthResponse> signUpWithEmail({
    required String fullname,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      return await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullname, 'username': username},
      );
    } catch (e) {
      rethrow;
    }
  }

  // dăng nhập bằng email & password
  Future<void> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      //Tìm email dựa trên username từ bảng 'profile_sleep_app'

      final response = await supabaseClient
          .from('profile_sleep_app')
          .select('email')
          .eq('username', username.trim())
          .maybeSingle(); // Trả về 1 dòng duy nhất hoặc null nếu không thấy

      // Nếu không tìm thấy username trong hệ thống
      if (response == null || response['email'] == null) {
        throw AuthApiException(
          'Tên đăng nhập hoặc mật khẩu không chính xác .',
          statusCode: '404',
        );
      }

      final String realEmail = response['email'];

      // Gọi hàm đăng nhập bằng email tìm được
      await supabaseClient.auth.signInWithPassword(
        email: realEmail,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  //Hàm verify otp
  Future<void> verifyEmail({required String email, required String otp}) async {
    try {
      await supabaseClient.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );
    } catch (e) {
      rethrow;
    }
  }

  // đăng nhập bằng Google
  Future<void> signInWithGoogle() async {
    try {
      await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      rethrow;
    }
  }

  // gửi lại OTP
  Future<void> resendOTP({required String email}) async {
    try {
      await supabaseClient.auth.resend(email: email, type: OtpType.signup);
    } catch (e) {
      rethrow;
    }
  }

  // reset password
  Future<bool> resetPassword({required String email}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      rethrow;
    }
  }

// xac minh otp reset password
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

// new pass
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      rethrow;
    }
  }
  // Check trùng username dựa vào bảng public profile
  Future<bool> isUsernameExist(String username) async {
    final response = await supabaseClient
        .from('profile_sleep_app')
        .select('username')
        .eq('username', username)
        .maybeSingle(); // Nếu tìm thấy trả về 1 bản ghi, không thấy trả về null

    return response != null;
  }

  // Check trùng email dựa vào bảng public profile
  Future<bool> isEmailExist(String email) async {
    final response = await supabaseClient
        .from('profile_sleep_app')
        .select('email')
        .eq('email', email)
        .maybeSingle();

    return response != null;
  }
}
