import 'package:restaurant_app/data/datasources/auth_local_data_source.dart';
import 'package:restaurant_app/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_app/domain/entities/user.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> register(String email, String password, String name) async {
    final user = await authRemoteDataSource.register(email, password, name);
    return user;
  }

  @override
  Future<User> login(String email, String password) async {
    final user = await authRemoteDataSource.login(email, password);
    await localDataSource.saveUser(user);
    return user;
  }

  @override
  Future<void> resetPassword(String email) async {
    await authRemoteDataSource.resetPassword(email);
  }

  @override
  Future<void> signOut() async {
    await authRemoteDataSource.logout();
    await localDataSource.deleteUser();
  }

  @override
  Future<User?> getCurrentUser() async {

    final localUser = await localDataSource.getUser();
    if (localUser != null) {
      return localUser;
    }

    final user = await authRemoteDataSource.getCurrentUser();
    if (user != null) {
      await localDataSource.saveUser(user);
      return user;
    }

    return null;
  }
}
