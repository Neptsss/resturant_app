import 'package:dartz/dartz.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/domain/repositories/restaurant_repository.dart';

class GetRestaurantByIdUsecase {
  final RestaurantRepository repository;
  GetRestaurantByIdUsecase(this.repository);

  Future<Either<String, Restaurant>> execute(int id) {
    return repository.getRestaurantById(id);
  }
}
