import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String packageId;
  final int passengersCount;
  final double totalAmount;
  final DateTime bookingDate;
  final String status;
  final String paymentStatus;

  BookingModel({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.passengersCount,
    required this.totalAmount,
    required this.bookingDate,
    required this.status,
    required this.paymentStatus,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      packageId: data['packageId'] ?? '',
      passengersCount: data['passengersCount'] ?? 1,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      paymentStatus: data['paymentStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'packageId': packageId,
      'passengersCount': passengersCount,
      'totalAmount': totalAmount,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'status': status,
      'paymentStatus': paymentStatus,
    };
  }
}
