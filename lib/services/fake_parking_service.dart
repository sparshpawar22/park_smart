import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class FakeParkingService {
  /// Generates fake parking spots nearby the user's current position
  static List<LatLng> generateNearbySpots(Position pos, int count) {
    final List<LatLng> spots = [];
    final random = Random();
    const double minDistanceKm = 0.1;
    const double maxDistanceKm = 0.4;
    const double minGapKm = 0.1;

    final baseLat = pos.latitude;
    final baseLon = pos.longitude;

    while (spots.length < count) {
      final distanceKm = minDistanceKm + random.nextDouble() * (maxDistanceKm - minDistanceKm);
      final angle = random.nextDouble() * 2 * pi;

      final deltaLat = distanceKm / 111.0;
      final deltaLon = distanceKm / (111.0 * cos(baseLat * pi / 180));
      final latOffset = deltaLat * cos(angle);
      final lonOffset = deltaLon * sin(angle);

      final newLat = baseLat + latOffset;
      final newLon = baseLon + lonOffset;
      final newSpot = LatLng(newLat, newLon);

      final isFarEnough = spots.every((spot) {
        final distance = Geolocator.distanceBetween(
          spot.latitude, spot.longitude,
          newLat, newLon,
        );
        return distance >= minGapKm * 1000;
      });

      if (isFarEnough) {
        spots.add(newSpot);
      }
    }

    return spots;
  }

  /// Finds the nearest parking spot from a list of spots
  static LatLng findNearestSpot(LatLng currentLocation, List<LatLng> spots) {
    LatLng nearest = spots[0];
    double minDistance = double.infinity;

    for (var spot in spots) {
      final distance = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        spot.latitude,
        spot.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearest = spot;
      }
    }

    return nearest;
  }
}
