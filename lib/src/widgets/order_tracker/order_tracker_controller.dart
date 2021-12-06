import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/models/role_model.dart';
import 'package:food_delivery/src/providers/map_provider.dart';
import 'package:food_delivery/src/providers/order_provider.dart';
import 'package:food_delivery/src/providers/socket_provider.dart';
import 'package:food_delivery/src/utils/launch_url.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';

class OrderTrackerController {
  late SocketProvider deliveryTrackerSocket;
  late BuildContext context;
  late Function updateView;
  late Position deliveryPosition;
  late BitmapDescriptor deliveryMarker;
  late BitmapDescriptor clientMarker;
  StreamSubscription? deliveryPositionStream;
  MapProvider mapProvider = MapProvider();
  OrderProvider orderProvider = OrderProvider();
  Completer<GoogleMapController> mapController = Completer();
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(14.6477112, -90.4808864),
    zoom: 18,
  );
  Map<MarkerId, Marker> markers = {};
  Order order = Order();
  bool isDelivery = false;
  bool detailExpanded = false;
  ScrollController detailScrollController = ScrollController();
  Address address = Address(latitude: 0, longitude: 0);
  Set<Polyline> polylines = {};

  Future<void> init(BuildContext context, Function updateView, Order order, List<Role> currentRoles) async {
    this.context = context;
    this.updateView = updateView;
    this.order = order;
    checkIsDelivery(currentRoles);
    deliveryMarker = await createMarkerFromAsset('assets/images/location-icon.png');
    clientMarker = await createMarkerFromAsset('assets/images/destination-icon.png');
    deliveryTrackerSocket = SocketProvider(
      nameSpace: 'orders/delivery/tracker',
      query: { 'order': this.order.id },
      autoConnect: true,
    );
    if (!isDelivery) deliveryTrackerSocket.on('position/${order.id}', onDeliveryPositionUpdate);
    updateView();
    verifyGPS();
  }

  void onDeliveryPositionUpdate(dynamic data) {
    final double latitude = data['latitude'];
    final double longitude = data['longitude'];

    addMarker('delivery', latitude, longitude, 'Ubicación Actual', '', deliveryMarker);
  }

  void emitDeliveryPosition() {
    deliveryTrackerSocket.emit('position', {
      'order': order.id,
      'latitude': deliveryPosition.latitude,
      'longitude': deliveryPosition.longitude,
    });
  }

  void checkIsDelivery(List<Role> currentRoles) {
    for (Role role in currentRoles) {
      if (role.name == 'DELIVERY') {
        isDelivery = true;
        break;
      }
    }
  }

  void goBack() => Navigator.pop(context, null);

  Future<void> setPolylines(LatLng from, LatLng to, String polylineId) async {
    Polyline polyline = await mapProvider.getPolylineByCoordinates(from, to, polylineId);
    polylines.add(polyline);
    updateView();
  }

  void openGoogleMaps() {
    LaunchUrl.openGoogleMaps(order.address!.latitude, order.address!.longitude);
  }

  void openWaze() {
    LaunchUrl.openWaze(order.address!.latitude, order.address!.longitude);
  }

  bool verifyDeliverOrder() {
    double distanceToClient = Geolocator.distanceBetween(
      deliveryPosition.latitude,
      deliveryPosition.longitude,
      order.address!.latitude,
      order.address!.longitude,
    );
    
    return distanceToClient <= 100;
  }

  Future<void> deliverOrder() async {
    if (!verifyDeliverOrder()) {
      CustomSnackBar.showError(
        context: context,
        title: 'Aviso',
        message: 'Debes estar cerca del cliente',
        margin: const EdgeInsets.only(left: 41, right: 41, top: 7),
      );
      return;
    }

    await orderProvider.editStatus(order.id!, OrderStatus.entregado);
    CustomSnackBar.showSuccess(
      context: context,
      title: 'Felicidades',
      message: 'Orden entregada',
      margin: const EdgeInsets.only(left: 41, right: 41, top: 7),
    );
    Navigator.pushNamedAndRemoveUntil(context, 'delivery/order/list', (route) => false);
  }

  void addMarker(String id, double lat, double lng, String title, String content, BitmapDescriptor icon) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: MarkerId(id),
      icon: icon,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[markerId] = marker;
    updateView();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text","stylers":[{"visibility":"on"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","stylers":[{"visibility":"on"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.attraction","stylers":[{"visibility":"on"}]},{"featureType":"poi.park","stylers":[{"visibility":"on"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","stylers":[{"visibility":"on"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","stylers":[{"visibility":"on"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    mapController.complete(controller);
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

  void positionListener(Position position) {
    deliveryPosition = position;
    emitDeliveryPosition();
    addMarker('delivery', position.latitude, position.longitude, 'Ubicación Actual', '', deliveryMarker);

    animateMapCamera(position.latitude, position.longitude);
    updateView();
  }

  void updateMapLocation() async {
    try {
      if (isDelivery) {
        deliveryPosition = await determinePosition();
        await animateMapCamera(deliveryPosition.latitude, deliveryPosition.longitude);
        await saveDeliveryPosition(deliveryPosition.latitude, deliveryPosition.longitude);
        addMarker(
          'delivery',
          deliveryPosition.latitude,
          deliveryPosition.longitude,
          'Ubicación Actual',
          '',
          deliveryMarker,
        );

      } else {
        await animateMapCamera(order.address!.latitude, order.address!.longitude);
        addMarker(
          'delivery',
          order.deliveryLatitude ?? 0,
          order.deliveryLongitude ?? 0,
          'Ubicación De Repartidor',
          '',
          deliveryMarker,
        );
      }
      
      addMarker(
        'client',
        order.address!.latitude,
        order.address!.longitude,
        'Ubicación De Entrega',
        '',
        clientMarker,
      );

      LatLng deliveryCoordinates = LatLng(deliveryPosition.latitude, deliveryPosition.longitude);
      LatLng clientCoordinates = LatLng(order.address!.latitude, order.address!.longitude);

      setPolylines(deliveryCoordinates, clientCoordinates, 'mapRoute');

      if (isDelivery) {
        deliveryPositionStream = Geolocator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best,
          distanceFilter: 1
        ).listen(positionListener);
      }


    } catch (e) {
      Logger().d('Error: $e');
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

  Future<BitmapDescriptor> createMarkerFromAsset(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, path);

    return descriptor;
  }

  Future<void> callUser() async {
    //await LaunchUrl.phoneCall(isDelivery ? order.user!.phone : order.delivery!.phone);
  }

  Future<void> sendUserEmail() async {
    await LaunchUrl.sendEmail(isDelivery ? order.user!.email : order.delivery!.email);
  }

  Future<void> saveDeliveryPosition(double latitude, double longitude) async {
    await orderProvider.edit(order.id!, Order(deliveryLatitude: latitude, deliveryLongitude: longitude));
  }

  void expandOrderDetail() {
    if (detailExpanded) {
      detailScrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInBack);
    }
    detailExpanded = !detailExpanded;
    updateView();
  }

  void dispose() {
    deliveryPositionStream?.cancel();
    deliveryTrackerSocket.disconnect();
  }

}
