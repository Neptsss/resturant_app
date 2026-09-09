import 'package:flutter/widgets.dart';
import 'package:restaurant_app/domain/entities/banner.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/domain/usecase/get_banner_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_usecase.dart';

class RestaurantProvider extends ChangeNotifier {
  final GetRestaurantUsecase getRestaurantUsecase;
  final GetBannerUsecase getBannerUsecase;

  RestaurantProvider({
    required this.getRestaurantUsecase,
    required this.getBannerUsecase,
  });

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  List<BannerItem> _banners = [];
  List<BannerItem> get banners => _banners;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> getAllRestaurants() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await getRestaurantUsecase.execute();
    result.fold(
      (failure) {
        _errorMessage = failure;
        _isLoading = false;
      },
      (restaurants) {
        _restaurants = restaurants;
        _isLoading = false;
      },
    );
    notifyListeners();
  }

  Future<void> getAllBanners() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await getBannerUsecase.execute();
    result.fold(
      (failure) {
        _errorMessage = failure;
        _isLoading = false;
      },
      (banners) {
        _banners = banners;
        _isLoading = false;
      },
    );
    notifyListeners();
  }



}
