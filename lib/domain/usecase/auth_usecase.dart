import 'package:restaurant_app/domain/entities/user.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<User> register(String email, String password, String name) {
    return _authRepository.register(email, password, name);
  }

  Future<User> login(String email, String password) {
    return _authRepository.login(email, password);
  }
  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }
  Future<void> logout() async {
    await _authRepository.signOut();
  }
  Future<User?> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }


}
