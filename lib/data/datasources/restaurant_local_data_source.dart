import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:restaurant_app/data/models/banner_model.dart';
import 'package:restaurant_app/data/models/resturant_model.dart';

abstract class RestaurantLocalDataSource {
  Future<List<RestaurantModel>> getRestaurants();
  Future<List<BannerModel>> getBanners();
  Future<RestaurantModel> getRestaurantById(int id);
}

class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/data.json',
      );
      final data = json.decode(response);
      return (data['restaurants'] as List)
          .map((e) => RestaurantModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  @override
  Future<RestaurantModel> getRestaurantById(int id) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/data.json',
      );
      final data = json.decode(response);
      final a =  (data['restaurants'] as List).firstWhere((e) => e['id'] == id);
      if(a == null){
        throw Exception('Restaurant not found');
      }
      return RestaurantModel.fromJson(a);

    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/data.json',
      );
      final data = json.decode(response);
      return (data['banners'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load banners');
    }
  }
}
