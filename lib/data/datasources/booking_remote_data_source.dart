import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/data/models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> createBooking(BookingModel booking);
  Future<List<BookingModel>> getBookings();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore _firestore;
  BookingRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(booking.id)
          .set(booking.toJson());
    } catch (e) {
      throw Exception('Failed to create booking : $e');
    }
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      return snapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bookings : $e');
    }
  }

  
}
