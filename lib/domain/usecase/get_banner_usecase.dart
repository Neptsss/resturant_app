import 'package:dartz/dartz.dart';
import 'package:restaurant_app/domain/entities/banner.dart';
import 'package:restaurant_app/domain/repositories/restaurant_repository.dart';

class GetBannerUsecase {
  final RestaurantRepository repository; 
  GetBannerUsecase(this.repository);

  Future<Either<String, List<BannerItem>>> execute(){
    return repository.getBanners();
  }
}