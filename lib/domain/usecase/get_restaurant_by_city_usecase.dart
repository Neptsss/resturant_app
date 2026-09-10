import 'package:dartz/dartz.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/domain/repositories/restaurant_repository.dart';

class GetRestaurantByCityUsecase {
  final RestaurantRepository repository; 

  GetRestaurantByCityUsecase({ required this.repository});

  Future<Either<String, List<Restaurant>>> execute(String city){
return repository.getRestaurantsByCity(city);
  }
}