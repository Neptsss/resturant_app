import 'package:restaurant_app/domain/entities/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.restaurantId,
    required super.email,
    required super.name,
    required super.numberOfSeats,
    required super.dateTime,
    required super.userId,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      numberOfSeats: json['numberOfSeats']?.toInt() ?? 0,
      dateTime: DateTime.parse(json['dateTime']),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'email': email,
      'name': name,
      'numberOfSeats': numberOfSeats,
      'dateTime': dateTime.toIso8601String(),
      'userId': userId,
    };
  }

  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      id: booking.id,
      restaurantId: booking.restaurantId,
      email: booking.email,
      name: booking.name,
      numberOfSeats: booking.numberOfSeats,
      dateTime: booking.dateTime,
      userId: booking.userId,
    );
  }
}
