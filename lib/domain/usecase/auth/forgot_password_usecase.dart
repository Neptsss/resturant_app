import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/errors/failures.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository _authRepository;

  ForgotPasswordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<Either<Failure, bool>> execute(String email) async {
    try {
      await _authRepository.resetPassword(email);
      return Right(true);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
