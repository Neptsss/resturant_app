import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/domain/entities/user.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _authRepository;

  RegisterUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<Either<Failure, User>> execute(
    String email,
    String password,
    String name,
  ) async {
    try {
      final user = await _authRepository.register(email, password, name);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
