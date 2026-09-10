import 'package:flutter/widgets.dart';
import 'package:restaurant_app/domain/entities/banner.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/domain/usecase/get_banner_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_by_city_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_by_id_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_restaurant_usecase.dart';

enum SortType { nameAsc, nameDesc }

class RestaurantProvider extends ChangeNotifier {
  final GetRestaurantUsecase getRestaurantUsecase;
  final GetBannerUsecase getBannerUsecase;
  final GetRestaurantByIdUsecase getRestaurantByIdUsecase;
  final GetRestaurantByCityUsecase getRestaurantByCityUsecase;

  RestaurantProvider({
    required this.getRestaurantUsecase,
    required this.getBannerUsecase,
    required this.getRestaurantByIdUsecase,
    required this.getRestaurantByCityUsecase,
  });

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  Restaurant? _selectedRestaurant;
  Restaurant? get selectedRestaurant => _selectedRestaurant;

  List<BannerItem> _banners = [];
  List<BannerItem> get banners => _banners;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCity = '';
  String get selectedCity => _selectedCity;

  SortType _sortType = SortType.nameAsc;
  SortType get sortType => _sortType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> getAllRestaurants() async {
    _selectedCity = '';
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

  Future<void> getResturantsByCity(String city) async {
    _isLoading = true;
    _errorMessage = '';
    _selectedCity = city;
    notifyListeners();

    final result = await getRestaurantByCityUsecase.execute(city);

    result.fold(
      (failure) {
        _errorMessage = failure;
        _isLoading = false;
      },
      (restaurants) {
        _restaurants = restaurants;
        _applySorting();
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

  void setSearchQuery(String v) {
    _searchQuery = v;
    notifyListeners();
  }

  void toggleSortType() {
    _sortType = _sortType == SortType.nameAsc
        ? SortType.nameDesc
        : SortType.nameAsc;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    switch (_sortType) {
      case SortType.nameAsc:
        _restaurants.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.nameDesc:
        _restaurants.sort((a, b) => b.name.compareTo(a.name));
    }
  }
}
