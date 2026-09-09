import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/domain/entities/user.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _authRepository;

  LoginUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<Either<Failure, User>> execute(
    String email,
    String password,
  ) async {
    try {
      final user = await _authRepository.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
