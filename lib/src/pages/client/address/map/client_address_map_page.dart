import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/pages/client/address/map/client_address_map_controller.dart';

class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({Key? key}) : super(key: key);

  @override
  _ClientAddressMapPageState createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {
  final _controller = ClientAddressMapController();

  updateView() => setState(() {});

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Container(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _map(),
            Positioned(
              bottom: 42,
              width: width,
              child: _selectAddressButton(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _controller.goBack,
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(2),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 30, color: Colors.black),
            ),
            const Text(
              'Selecciona tu ubicación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                shadowColor: Colors.transparent,
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: const Icon(Icons.more_horiz, size: 30, color: Colors.black),
            ),
          ],
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
    );
  }

  Widget _selectAddressButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
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
    );
  }

}