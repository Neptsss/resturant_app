import 'package:restaurant_app/domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  RestaurantModel({
    required super.id,
    required super.name,
    required super.image,
    required super.latitude,
    required super.longtitude,
    required super.address,
    required super.city,
    required super.description,
    required List<OpeningHourModel> super.openingHours,
    required List<MenuItemModel> super.menu,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      latitude: json['latitude']?.toDouble(),
      longtitude: json['longitude']?.toDouble(),
      address: json['address'],
      city: json['city'],
      description: json['description'],
      openingHours:
          (json['opening_hours'] as List?)
              ?.map((e) => OpeningHourModel.fromJson(e))
              .toList() ??
          [],
      menu:
          (json['menu'] as List?)
              ?.map((e) => MenuItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OpeningHourModel extends OpeningHour {
  OpeningHourModel({required super.day, required super.hours});

  factory OpeningHourModel.fromJson(Map<String, dynamic> json) {
    return OpeningHourModel(day: json['day'], hours: json['hours']);
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'hours': hours};
  }
}

class MenuItemModel extends MenuItem {
  MenuItemModel({
    required super.name,
    required super.image,
    required super.description,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      name: json['name'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image, 'description': description};
  }
}
