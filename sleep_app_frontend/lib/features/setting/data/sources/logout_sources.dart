import '../../../../main.dart';
class LogoutRemoteDataSource {
  

  Future<void> signOut() async {
    try{
      await supabaseClient.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}