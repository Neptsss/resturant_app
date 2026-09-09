import 'package:restaurant_app/domain/entities/banner.dart';

class BannerModel extends BannerItem {
  BannerModel({required super.id, required super.image});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(id: json['id'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image};
  }
}
