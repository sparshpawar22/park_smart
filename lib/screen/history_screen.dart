import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    final bookingsQuery = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingsQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No booking history found'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data()! as Map<String, dynamic>;

              final rawStatus = (data['status'] ?? '').toString().trim().toLowerCase();

              final isCompleted = rawStatus == 'completed';
              final isCancelled = rawStatus == 'cancelled' || rawStatus == 'canceled' || rawStatus == 'cancel';

              // Choose card and text colors based on status
              Color cardColor;
              Color statusColor;
              String displayStatus;

              if (isCompleted) {
                cardColor = Colors.green.shade100;
                statusColor = Colors.green.shade800;
                displayStatus = 'COMPLETED';
              } else if (isCancelled) {
                cardColor = Colors.red.shade100;
                statusColor = Colors.red.shade800;
                displayStatus = 'CANCELLED';
              } else {
                cardColor = Colors.grey.shade200;
                statusColor = Colors.grey.shade600;
                displayStatus = rawStatus.toUpperCase();
              }

              // Format timestamp
              String formattedDate = 'Unknown date';
              try {
                if (data['timestamp'] != null) {
                  final Timestamp ts = data['timestamp'];
                  final dateTime = ts.toDate();
                  formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
                }
              } catch (_) {}

              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, size: 20, color: statusColor),
                          const SizedBox(width: 8),
                          const Text(
                            "Status: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            displayStatus,
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(data['location'] ?? 'No location'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.local_parking, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(data['slot'] ?? 'No slot info'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 20),
                          const SizedBox(width: 8),
                          Text("Duration: ${data['duration'] ?? '-'} hour(s)"),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, size: 20),
                          const SizedBox(width: 8),
                          Text("Cost: ₹${(data['cost'] ?? 0).toStringAsFixed(2)}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            "Booked On: $formattedDate",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
