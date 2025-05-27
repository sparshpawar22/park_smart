import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'slot_selection_screen.dart';

class ParkingSheet extends StatelessWidget {
  final LatLng userLocation;
  final LatLng spotLocation;
  final String slotName;
  final void Function(String name, int time, double price) onBookingConfirmed;

  const ParkingSheet({
    super.key,
    required this.userLocation,
    required this.spotLocation,
    required this.slotName,
    required this.onBookingConfirmed,
  });

  double _calculateDistanceInKm() {
    return Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      spotLocation.latitude,
      spotLocation.longitude,
    ) / 1000;
  }

  @override
  Widget build(BuildContext context) {
    final distance = _calculateDistanceInKm();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Parking Spot",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text("Distance to spot: ${distance.toStringAsFixed(2)} km"),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pop(); // Close bottom sheet

              final bookingDetails = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SlotSelectionScreen(),
                ),
              );

              if (bookingDetails != null && bookingDetails is Map) {
                onBookingConfirmed(
                  bookingDetails['name'],
                  bookingDetails['time'],
                  bookingDetails['price'],
                );
              }
            },
            icon: const Icon(Icons.directions_car),
            label: const Text("Book Spot"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
