import 'package:restaurant_app/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<void> createBooking(Booking booking);
  Future<List<Booking>> getBookings();
}
