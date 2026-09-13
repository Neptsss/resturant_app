import 'package:flutter/widgets.dart';
import 'package:restaurant_app/domain/entities/booking.dart';
import 'package:restaurant_app/domain/usecase/create_booking_usecase.dart';
import 'package:restaurant_app/domain/usecase/get_booking_usecase.dart';
import 'package:uuid/uuid.dart';

class BookingProvider extends ChangeNotifier {
  final CreateBookingUsecase _createBookingUsecase;
  final GetBookingUseCase _getBookingUsecase;

  BookingProvider({
    required this._createBookingUsecase,
    required this._getBookingUsecase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  Future<bool> createBooking({
    required String restaurantId,
    required String email,
    required String name,
    required int numberOfSeats,
    required DateTime dateTime,
    required String userId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();
      final booking = Booking(
        id: const Uuid().v4(),
        restaurantId: restaurantId,
        email: email,
        name: name,
        numberOfSeats: numberOfSeats,
        dateTime: dateTime,
        userId: userId,
      );

      await _createBookingUsecase.execute(booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();
      return false;
    }
  }

  Future<void> getBookings() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      _bookings = await _getBookingUsecase.execute();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
