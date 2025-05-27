import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/fake_parking_service.dart';
import '../../services/location_service.dart';
import '../../services/route_services.dart';
import '../../auth/auth_service.dart';
import '../../services/booking_service.dart';
import '../parking_sheet.dart';

class HomeController {
  late BuildContext _context;
  late void Function(VoidCallback fn) _setState;

  GoogleMapController? mapController;
  LatLng? currentLocation;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  List<LatLng> parkingSpots = [];

  final RouteService _routeService = RouteService();
  final BookingService _bookingService = BookingService();

  bool bookingActive = false;
  LatLng? bookedSpot;

  // Booking Details
  String userName = "";
  int duration = 0;
  String slotName = "";
  double cost = 0.0;

  void init(BuildContext context, void Function(VoidCallback fn) setState) {
    _context = context;
    _setState = setState;
    _loadLocationAndMarkers();
  }

  Future<void> _loadLocationAndMarkers() async {
    try {
      final position = await LocationService.getCurrentLocation();
      final userLatLng = LatLng(position.latitude, position.longitude);
      final fakeSpots = FakeParkingService.generateNearbySpots(position, 5);

      _setState(() {
        currentLocation = userLatLng;
        parkingSpots = fakeSpots;

        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: userLatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        );

        for (int i = 0; i < fakeSpots.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId("parking_$i"),
              position: fakeSpots[i],
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: "Parking Spot ${i + 1}"),
              onTap: () => _showParkingSheet(fakeSpots[i], "Spot ${i + 1}"),
            ),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
    }
  }

  void _showParkingSheet(LatLng spot, String slot) {
    showModalBottomSheet(
      context: _context,
      isScrollControlled: true,
      builder: (_) => ParkingSheet(
        userLocation: currentLocation!,
        spotLocation: spot,
        slotName: slot,
        onBookingConfirmed: (String name, int time, double price) {
          userName = name;
          duration = time;
          cost = price;
          slotName = slot;
          _onBookingConfirmed(spot);
        },
      ),
    );
  }

  Future<void> _onBookingConfirmed(LatLng spot) async {
    if (currentLocation == null) return;

    try {
      final routeCoords = await _routeService.getRouteCoordinates(currentLocation!, spot);

      _setState(() {
        bookingActive = true;
        bookedSpot = spot;

        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId("booked_spot"),
            position: spot,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: const InfoWindow(title: "Your Booked Spot"),
          ),
        );
        markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: currentLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: "You"),
          ),
        );
        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: routeCoords,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text("Failed to load route: $e")),
      );
    }
  }

  void resetMap() {
    _setState(() {
      bookingActive = false;
      bookedSpot = null;
      polylines.clear();
    });
    _loadLocationAndMarkers();
  }

  void confirmAction(String title, String message, String status) {
    showDialog(
      context: _context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(_context);
              await _storeBooking(status);
              resetMap();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _storeBooking(String status) async {
    final user = AuthService().currentUser;
    if (user == null || bookedSpot == null) return;

    final name = user.displayName ?? "Guest";
    final location = "Lat: ${bookedSpot!.latitude}, Lng: ${bookedSpot!.longitude}";
    final slot = "Spot at (${bookedSpot!.latitude.toStringAsFixed(4)}, ${bookedSpot!.longitude.toStringAsFixed(4)})";

    await _bookingService.saveBooking(
      name: name,
      status: status,
      location: location,
      duration: duration,
      slot: slot,
      cost: cost,
    );
  }

  Future<void> handleLogout() async {
    await AuthService().signOut();
  }
}
