import 'dart:ui';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/widgets/custom_fade_in_image.dart';
import 'package:food_delivery/src/widgets/order_tracker/order_tracker_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

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
            _locationButton(),
            _deliverOrderButton(),
            _cardOrderWidget(),
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

  Widget _locationButton() {
    return Positioned(
      top: 115,
      left: 42,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: ElevatedButton(
              onPressed: _controller.updateMapLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                elevation: 0,
                minimumSize: const Size(55, 55),
                primary: Colors.black.withOpacity(0.9),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Icon(FlutterIcons.my_location_mdi, size: 26, color: Colors.white),
            ),
        ),
      ),
    );
  }

  Widget _map() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.3),
      child: GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: _controller.cameraPosition,
        onMapCreated: _controller.onMapCreated,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        onCameraMove: (position) => _controller.cameraPosition = position,
        onCameraIdle: () {},
        markers: Set.of(_controller.markers.values),
      ),
    );
  }

  Widget _cardOrderWidget() {
    return Container(
      height: 370,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: _clientSection(),
            ),
          ),
          Positioned.fill(
            top: 120,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: _orderDetail(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clientSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          child: CustomFadeInImage(
                            image: _controller.order.user?.image ?? 'assets/images/profile-image.png',
                            placeholder: 'assets/images/profile-image.png',
                            fit: BoxFit.contain,
                            size: const Size(55, 55),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(FlutterIcons.shopping_bag_ent, color: Colors.white, size: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_controller.order.user?.firstName} ${_controller.order.user?.lastName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${_controller.order.user?.email}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                        color: const Color(0XFFFF8C3E),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () => _controller.sendUserEmail(_controller.order.user?.email ?? ''),
                        icon: const Icon(FlutterIcons.md_mail_ion, color: Colors.white, size: 23.5),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.only(top: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0XFFFF8C3E),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () => _controller .sendUserEmail(_controller.order.user?.email ?? ''),
                        icon: const Icon(FlutterIcons.phone_faw, color: Colors.white, size: 25),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _orderDetail() {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dirección de entrega',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0XFFA2A2A2),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0XFFf4f4f4),
                  borderRadius: BorderRadius.circular(18),
                  image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/location.png'),
                  ),
                ),
                child: Image.asset(
                  'assets/images/location.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '${_controller.order.address?.address}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'Tiempo de llegada',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0XFFA2A2A2),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0XFFf4f4f4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.asset(
                  'assets/images/time.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Llegada estimada en 3 min...',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliverOrderButton() {
    return Positioned(
      right: 42,
      top: 42,
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
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
              const Text('Entregar Orden', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.check_rounded, size: 27),
              ),
            ],
          ),
        ),
      ),
    );
  }

}