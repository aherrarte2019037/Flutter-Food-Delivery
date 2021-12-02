import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';

class MapPageController {
  late BuildContext context;
  late Function updateView;
  late Position userPosition;
  final Completer<GoogleMapController> mapController = Completer();
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(14.6477112, -90.4808864),
    zoom: 18,
  );
  Address address = Address(latitude: 0, longitude: 0);

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
    verifyGPS();
  }

  void goBack() => Navigator.pop(context, null);

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text","stylers":[{"visibility":"on"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","stylers":[{"visibility":"on"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.attraction","stylers":[{"visibility":"on"}]},{"featureType":"poi.park","stylers":[{"visibility":"on"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","stylers":[{"visibility":"on"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","stylers":[{"visibility":"on"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    mapController.complete(controller);
  }

  Future setDraggableAddress() async {
    address.latitude = cameraPosition.target.latitude;
    address.longitude = cameraPosition.target.longitude;

    List<Placemark> addresses = await placemarkFromCoordinates(address.latitude, address.longitude);
    if (addresses.isNotEmpty) {
      String direction = addresses[0].thoroughfare ?? '';
      String street = addresses[0].subThoroughfare ?? '';
      String city = addresses[0].locality ?? '';

      address.address = '$direction $street $city'.trim();
      updateView();
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) return Future.error('Permissions are permanently denied');
  
    return await Geolocator.getCurrentPosition();
  }

  void updateMapLocation() async {
    try {
      userPosition = await determinePosition();
      await animateMapCamera(userPosition.latitude, userPosition.longitude);

    } catch (e) {
      Logger().d(e);
    }
  }

  Future<void> verifyGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateMapLocation();
      return;
    }

    bool locationGPS = await location.Location().requestService();
    if (locationGPS) updateMapLocation();
  }

  Future<void> animateMapCamera(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 18,
      bearing: 0,
    )));
  }

  void selectAddress() {
    Navigator.pop(context, address);
  }

}
