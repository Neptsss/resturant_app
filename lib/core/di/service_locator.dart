import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:get_it/get_it.dart';
import 'package:restaurant_app/data/datasources/auth_local_data_source.dart';
import 'package:restaurant_app/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_app/data/datasources/booking_remote_data_source.dart';
import 'package:restaurant_app/data/datasources/restaurant_local_data_source.dart';
import 'package:restaurant_app/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_app/data/repositories/booking_repository_impl.dart';
import 'package:restaurant_app/data/repositories/restaurant_repository_impl.dart';
import 'package:restaurant_app/domain/repositories/auth_repository.dart';
import 'package:restaurant_app/domain/repositories/booking_repository.dart';
import 'package:restaurant_app/domain/repositories/restaurant_repository.dart';
import 'package:restaurant_app/domain/usecase/auth/forgot_password_usecase.dart';
import 'package:restaurant_app/domain/usecase/auth/login_usecase.dart';
import 'package:restaurant_app/domain/usecase/auth/register_usecase.dart';
import 'package:restaurant_app/domain/usecase/auth_usecase.dart';
import 'package:restaurant_app/domain/usecase/create_booking_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_banner_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_booking_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_by_city_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_by_id_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_usecase.dart';
import 'package:restaurant_app/presentation/providers/auth_providers.dart';
import 'package:restaurant_app/presentation/providers/booking_provider.dart';
import 'package:restaurant_app/presentation/providers/restaurant_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // initialisasi SharedPreference
  final sharedPref = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPref);

  // external services
  serviceLocator.registerLazySingleton(() {
    return fa.FirebaseAuth.instance;
  });
  serviceLocator.registerLazySingleton(() {
    return FirebaseFirestore.instance;
  });

  // Datasoruce
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(() {
    return AuthLocalDataSourceImpl(sp: serviceLocator());
  });
  serviceLocator.registerLazySingleton<RestaurantLocalDataSource>(() {
    return RestaurantLocalDataSourceImpl();
  });

  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() {
    return AuthRemoteDataSourceImpl(firebaseAuth: serviceLocator());
  });

  serviceLocator.registerLazySingleton<BookingRemoteDataSource>(() {
    return BookingRemoteDataSourceImpl(firestore: serviceLocator());
  });

  // repositories
  serviceLocator.registerLazySingleton<AuthRepository>(() {
    return AuthRepositoryImpl(
      authRemoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    );
  });
  serviceLocator.registerLazySingleton<RestaurantRepository>(() {
    return RestaurantRepositoryImpl(localDataSource: serviceLocator());
  });
  serviceLocator.registerLazySingleton<BookingRepository>(() {
    return BookingRepositoryImpl(remoteDataSource: serviceLocator());
  });

  // usecase
  serviceLocator.registerLazySingleton(() {
    return AuthUseCase(authRepository: serviceLocator());
  });

  serviceLocator.registerLazySingleton(() {
    return RegisterUsecase(authRepository: serviceLocator());
  });
  serviceLocator.registerLazySingleton(() {
    return LoginUsecase(authRepository: serviceLocator());
  });
  serviceLocator.registerLazySingleton(() {
    return ForgotPasswordUsecase(authRepository: serviceLocator());
  });

  
  //  Restaurant
  serviceLocator.registerLazySingleton(() {
    return GetRestaurantUsecase(serviceLocator());
  });
  serviceLocator.registerLazySingleton(() {
    return GetBannerUsecase(serviceLocator());
  });

  serviceLocator.registerLazySingleton(() {
    return GetRestaurantByIdUsecase(serviceLocator());
  });
  serviceLocator.registerLazySingleton(() {
    return GetRestaurantByCityUsecase(repository: serviceLocator());
  });

  // booking
  serviceLocator.registerLazySingleton(() {
    return CreateBookingUsecase(repository: serviceLocator());
  });
  serviceLocator.registerLazySingleton(() {
    return GetBookingUseCase(repository: serviceLocator());
  });

  // Provider
  serviceLocator.registerFactory<AuthProvider>(() {
    return AuthProvider(authUsecase: serviceLocator());
  });

  serviceLocator.registerFactory<RestaurantProvider>(() {
    return RestaurantProvider(
      getRestaurantUsecase: serviceLocator(),
      getBannerUsecase: serviceLocator(),
      getRestaurantByIdUsecase: serviceLocator(),
      getRestaurantByCityUsecase: serviceLocator(),
    );
  });

  serviceLocator.registerFactory<BookingProvider>(() {
    return BookingProvider(createBookingUsecase: serviceLocator(), getBookingUsecase: serviceLocator());
  });
}
