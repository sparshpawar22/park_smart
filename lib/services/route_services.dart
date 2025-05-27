import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteService {
  final String _apiKey = '5b3ce3597851110001cf6248c29b901c697545b4954741b45a371237';

  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$_apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coords = data['features'][0]['geometry']['coordinates'];

      return coords.map<LatLng>((point) => LatLng(point[1], point[0])).toList();
    } else {
      throw Exception('Failed to fetch route');
    }
  }
}
