import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:get_it/get_it.dart';
import 'package:restaurant_app/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_app/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';
import 'package:restaurant_app/domain/usecase/auth/register_usecase.dart';
import 'package:restaurant_app/domain/usecase/auth_usecase.dart';
import 'package:restaurant_app/presentation/providers/auth_providers.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // external services
  serviceLocator.registerLazySingleton(() {
    return fa.FirebaseAuth.instance;
  });

  // Datasoruce
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() {
    return AuthRemoteDataSourceImpl(firebaseAuth: serviceLocator());
  });

  // repositories
  serviceLocator.registerLazySingleton<AuthRepository>(() {
    return AuthRepositoryImpl(authRemoteDataSource: serviceLocator());
  });

  // usecase
  serviceLocator.registerLazySingleton(() {
    return AuthUseCase(authRepository: serviceLocator());
  });

  serviceLocator.registerLazySingleton(() {
    return RegisterUsecase(authRepository: serviceLocator());
  });

  // Provider
  serviceLocator.registerFactory<AuthProvider>(() {
    return AuthProvider(authUsecase: serviceLocator());
  });
}
