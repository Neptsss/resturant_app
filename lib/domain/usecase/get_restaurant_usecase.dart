import 'package:dartz/dartz.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/domain/repositories/restaurant_repository.dart';

class GetRestaurantUsecase {
  final RestaurantRepository repository;
  GetRestaurantUsecase(this.repository);

  Future<Either<String, List<Restaurant>>> execute() {
    return repository.getRestaurants();
  }
}
