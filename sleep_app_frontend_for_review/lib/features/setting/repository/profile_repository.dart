import '../data/sources/profile_sources.dart';
import '../data/models/user_models.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _dataSource;
  ProfileRepository(this._dataSource);

  Future<UserModel> getUserProfile(String userId) async {
    final data = await _dataSource.fetchUserProfile(userId);
    return UserModel.fromJson(
      data,
    ); // Map dữ liệu từ Supabase sang Model của bạn
  }

  Future<void> updateUserProfile(String userId, UserModel user) async {
    await _dataSource.updateUserProfile(userId, user.toJson());
  }
}
