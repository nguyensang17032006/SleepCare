import '../data/sources/logout_sources.dart';

class LogoutRepository {
  final LogoutRemoteDataSource _logoutRemoteDataSource;

  LogoutRepository(this._logoutRemoteDataSource);

  Future<void> logout() async {
    try {
      await _logoutRemoteDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
