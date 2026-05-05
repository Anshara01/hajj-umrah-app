import 'package:cloud_firestore/cloud_firestore.dart';

class PackageModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final int durationDays;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> amenities;
  final List<String> images;
  final bool isActive;

  PackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.amenities,
    required this.images,
    required this.isActive,
  });

  factory PackageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PackageModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      durationDays: data['durationDays'] ?? 0,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      amenities: List<String>.from(data['amenities'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      isActive: data['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'durationDays': durationDays,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'amenities': amenities,
      'images': images,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
