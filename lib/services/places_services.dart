// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class PlacesService {
//   final String apiKey;
//
//   PlacesService(this.apiKey);
//
//   Future<List<LatLng>> getNearbyParkingSpots(LatLng location, int radius) async {
//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//           '?location=${location.latitude},${location.longitude}'
//           '&radius=$radius'
//           '&type=parking'
//           '&keyword=parking'
//           '&key=$apiKey',
//     );
//
//     final response = await http.get(url);
//     print('Request URL: $url');
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//
//     if (response.statusCode != 200) {
//       throw Exception('Failed to load parking spots');
//     }
//
//     final data = jsonDecode(response.body);
//     final List<LatLng> spots = [];
//
//     for (var result in data['results']) {
//       final loc = result['geometry']['location'];
//       spots.add(LatLng(loc['lat'], loc['lng']));
//     }
//
//     return spots;
//   }
// }




//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../services/places_services.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   GoogleMapController? _controller;
//   LatLng? _currentLocation;
//   final Set<Marker> _markers = {};
//   late PlacesService _placesService;
//
//   final String _googleApiKey = 'AIzaSyCIFt4czpmEq73ZXF7HMTINpKjZ_Shqo8A';
//
//   @override
//   void initState() {
//     super.initState();
//     _placesService = PlacesService(_googleApiKey);
//     _requestPermissionAndFetchLocation();
//   }
//
//   Future<void> _requestPermissionAndFetchLocation() async {
//     final status = await Permission.location.request();
//
//     if (status.isGranted) {
//       await _fetchCurrentLocationAndNearbyParking();
//     } else {
//       // Permission denied, show error or prompt user accordingly
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location permission is required')),
//       );
//     }
//   }
//
//   Future<void> _fetchCurrentLocationAndNearbyParking() async {
//     try {
//       final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       _currentLocation = LatLng(position.latitude, position.longitude);
//
//       final parkingSpots = await _placesService.getNearbyParkingSpots(_currentLocation!, 2000);
//
//       final newMarkers = <Marker>{
//         Marker(
//           markerId: const MarkerId('current_location'),
//           position: _currentLocation!,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           infoWindow: const InfoWindow(title: 'You are here'),
//         ),
//       };
//
//       for (int i = 0; i < parkingSpots.length; i++) {
//         newMarkers.add(
//           Marker(
//             markerId: MarkerId('parking_$i'),
//             position: parkingSpots[i],
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//             infoWindow: InfoWindow(title: 'Parking Spot ${i + 1}'),
//           ),
//         );
//       }
//
//       setState(() {
//         _markers.clear();
//         _markers.addAll(newMarkers);
//       });
//
//       _controller?.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 15));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching location or parking spots: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Smart Parking')),
//       body: _currentLocation == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _currentLocation!,
//           zoom: 15,
//         ),
//         markers: _markers,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         onMapCreated: (controller) => _controller = controller,
//       ),
//     );
//   }
// }
