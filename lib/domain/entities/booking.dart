class Booking {
  final String id;
  final String restaurantId;
  final String email;
  final String name;
  final int numberOfSeats;
  final DateTime dateTime;
  final String userId;

  Booking({
    required this.id,
    required this.restaurantId,
    required this.email,
    required this.name,
    required this.numberOfSeats,
    required this.dateTime,
    required this.userId,
  });
}
