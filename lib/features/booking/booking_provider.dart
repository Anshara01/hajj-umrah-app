import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_provider.dart';
import 'booking_model.dart';

final userBookingsProvider = StreamProvider<List<BookingModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;

  if (user == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('bookings')
      .where('userId', isEqualTo: user.uid)
      .orderBy('bookingDate', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => BookingModel.fromFirestore(doc)).toList());
});

final bookingServiceProvider = Provider((ref) => BookingService());

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createBooking(BookingModel booking) async {
    await _db.collection('bookings').add(booking.toMap());
  }
}
