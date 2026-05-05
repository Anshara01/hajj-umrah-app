import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hajj_umrah_app/features/packages/package_model.dart'; // Will resolve once files are available

final packageProvider = StreamProvider<List<PackageModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('packages')
      .where('isActive', isEqualTo: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PackageModel.fromFirestore(doc)).toList());
});
