import 'package:flutter/widgets.dart';
import 'package:restaurant_app/domain/entities/banner.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/domain/usecase/get_banner_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_by_id_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_usecase.dart';

class RestaurantProvider extends ChangeNotifier {
  final GetRestaurantUsecase getRestaurantUsecase;
  final GetBannerUsecase getBannerUsecase;
  final GetRestaurantByIdUsecase getRestaurantByIdUsecase;

  RestaurantProvider({
    required this.getRestaurantUsecase,
    required this.getBannerUsecase,
    required this.getRestaurantByIdUsecase,
  });

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  Restaurant? _selectedRestaurant;
  Restaurant? get selectedRestaurant => _selectedRestaurant;

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

  Future<void> getRestaurantById(int id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    final result = await getRestaurantByIdUsecase.execute(id);

    result.fold(
      (failure) {
        _errorMessage = failure;
        _isLoading = false;
      },
      (restaurant) {
        _selectedRestaurant = restaurant;
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
