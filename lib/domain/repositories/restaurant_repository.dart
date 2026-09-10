import 'package:dartz/dartz.dart';
import 'package:restaurant_app/domain/entities/banner.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<Either<String, List<Restaurant>>> getRestaurants();
  Future<Either<String, List<BannerItem>>> getBanners();
  Future<Either<String, Restaurant>> getRestaurantById(int id);
  Future<Either<String, List<Restaurant>>> getRestaurantsByCity(String city);

}