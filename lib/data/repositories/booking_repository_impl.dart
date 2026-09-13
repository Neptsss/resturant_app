import 'package:restaurant_app/data/datasources/booking_remote_data_source.dart';
import 'package:restaurant_app/data/models/booking_model.dart';
import 'package:restaurant_app/domain/entities/booking.dart';
import 'package:restaurant_app/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;
  BookingRepositoryImpl({required this._remoteDataSource});

  @override
  Future<void> createBooking(Booking booking) async {
    try {
      await _remoteDataSource.createBooking(BookingModel.fromEntity(booking));
    } catch (e) {
      throw Exception('Failed to create booking : $e');
    }
  }

  @override
  Future<List<Booking>> getBookings() async {
    try {
      final bookings = await _remoteDataSource.getBookings();
      return bookings;
    } catch (e) {
      throw Exception('Failed to get bookings : $e');
    }
  }
}
