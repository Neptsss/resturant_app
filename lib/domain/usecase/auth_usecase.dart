import 'package:restaurant_app/domain/entities/user.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';

class AuthUseCase {
final AuthRepository _authRepository;

AuthUseCase({required AuthRepository authRepository }) : _authRepository = authRepository;

Future<User> register (String email, String password, String name){
  return _authRepository.register(email, password, name);
}

}