import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final CollectionReference _bookings =
  FirebaseFirestore.instance.collection('bookings');

  Future<void> saveBooking({
    required String name,
    required String status, // "complete" or "cancel"
    required String location,
    required int duration,
    required String slot,
    required double cost,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await _bookings.add({
      'userId': user.uid,
      'name': name,
      'status': status,
      'location': location,
      'duration': duration,
      'slot': slot,
      'cost': cost,
      'timestamp': Timestamp.now(),
    });
  }
}
