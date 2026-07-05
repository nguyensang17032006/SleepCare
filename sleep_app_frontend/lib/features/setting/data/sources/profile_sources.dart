import '../../../../main.dart';

class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    return await supabaseClient
        .from('profile_sleep_app')
        .select('*')
        .eq('id', userId)
        .single();
  }
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
  await supabaseClient.from('profile_sleep_app').update(data).eq('id', userId);
}
}

