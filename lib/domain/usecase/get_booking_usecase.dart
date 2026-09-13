import 'package:restaurant_app/domain/entities/booking.dart';
import 'package:restaurant_app/domain/repositories/booking_repository.dart';

class GetBookingUseCase {
  final BookingRepository _repository;

  GetBookingUseCase({required this._repository});

  Future<List<Booking>> execute() async {
    return await _repository.getBookings();
  }
}
