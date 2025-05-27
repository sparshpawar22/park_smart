import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_controller.dart';

class HomeMap extends StatelessWidget {
  final HomeController controller;

  const HomeMap({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: controller.currentLocation!,
        zoom: 16,
      ),
      onMapCreated: (c) => controller.mapController = c,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: controller.markers,
      polylines: controller.polylines,
    );
  }
}
