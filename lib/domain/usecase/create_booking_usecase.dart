import 'package:restaurant_app/domain/entities/booking.dart';
import 'package:restaurant_app/domain/repositories/booking_repository.dart';

class CreateBookingUsecase {
  final BookingRepository _repository;

  CreateBookingUsecase({required this._repository});

  Future<void> execute(Booking booking) async {
    return await _repository.createBooking(booking);
  }
}
