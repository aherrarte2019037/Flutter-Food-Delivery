import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/widgets/order_tracker/order_tracker_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

class OrderTracker extends StatefulWidget {
  final Order order;

  const OrderTracker({Key? key, required this.order}) : super(key: key);

  @override
  _OrderTrackerState createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker> {
  final _controller = OrderTrackerController();

  updateView() => setState(() {});

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _map(),
            _backButton(),
            _locationIcon(),
            _selectAddressButton(),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return Positioned(
      top: 42,
      left: 42,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: ElevatedButton(
              onPressed: _controller.goBack,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                elevation: 0,
                minimumSize: const Size(55, 55),
                primary: Colors.black.withOpacity(0.9),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 28, color: Colors.white),
            ),
        ),
      ),
    );
  }

  Widget _map() {
    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: _controller.cameraPosition,
      onMapCreated: _controller.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) => _controller.cameraPosition = position,
      onCameraIdle: () async => await _controller.setDraggableAddress(),
    );
  }

  Widget _locationIcon() {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/location-icon.png',
        fit: BoxFit.contain,
        height: 52,
        width: 52,
      ),
    );
  }

  Widget _selectAddressButton() {
    return Positioned(
      bottom: 42,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42),
        child: Container(
          height: 60,
          child: ElevatedButton(
            onPressed: _controller.selectAddress,
            style: ElevatedButton.styleFrom(
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              primary: Colors.black.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              textStyle: const TextStyle(
                fontSize: 16.5,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Seleccionar ubicación', style: TextStyle(color: Colors.white)),
                const Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Icon(FlutterIcons.location_arrow_faw, size: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}