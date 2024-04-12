import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteInfo {
  final List<LatLng> coordinates;
  final double duration;
  final String travelMode;

  RouteInfo({
    required this.coordinates,
    required this.duration,
    required this.travelMode,
  });
}
