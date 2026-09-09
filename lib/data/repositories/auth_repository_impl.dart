import 'package:restaurant_app/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_app/domain/entities/user.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  Future<User> register(String email, String password, String name) {
    return _authRemoteDataSource.register(email, password, name);
  }
}
