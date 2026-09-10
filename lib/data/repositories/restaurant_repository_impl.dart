import 'package:dartz/dartz.dart';
import 'package:restaurant_app/data/datasources/restaurant_local_data_source.dart';
import 'package:restaurant_app/domain/entities/banner.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantLocalDataSource localDataSource;

  RestaurantRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<String, List<BannerItem>>> getBanners() async {
    try {
      final result = await localDataSource.getBanners();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Restaurant>>> getRestaurants() async {
    try {
      final result = await localDataSource.getRestaurants();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Restaurant>> getRestaurantById(int id) async {
    try {
      final result = await localDataSource.getRestaurantById(id);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Restaurant>>> getRestaurantsByCity(
    String city,
  ) async {
    try {
      final result = await localDataSource.getRestaurantsByCity(city);
      return Right(result);
    } catch (e) {
      return left(e.toString());
    }
  }
}
