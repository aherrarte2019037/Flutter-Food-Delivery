import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider {
  final String _apiKeyMaps = dotenv.env['APIKEYMAPS']!;

  Future<Polyline> getPolylineByCoordinates(LatLng from, LatLng to, String polylineId) async {
    try {
      PointLatLng pointFrom = PointLatLng(from.latitude, from.latitude);
      PointLatLng pointTo = PointLatLng(to.latitude, to.latitude);

      PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(_apiKeyMaps, pointFrom, pointTo);
      List<LatLng> mapPoints = result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();

      Polyline polyline = Polyline(
        polylineId: PolylineId(polylineId),
        color: const Color(0XFFFF8C3E),
        points: mapPoints,
        width: 5,
      );

      return polyline;

    } catch (e) {
      print('Error: $e');
      
      Polyline polyline = Polyline(
        polylineId: PolylineId(polylineId),
        color: const Color(0XFFFF8C3E),
        points: [],
        width: 5,
      );
      return polyline;
    }
  }

}