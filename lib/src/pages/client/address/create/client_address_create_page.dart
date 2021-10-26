import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/pages/client/address/create/client_address_create_controller.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({Key? key}) : super(key: key);

  @override
  _ClientAddressCreatePageState createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  final _controller = ClientAddressCreateController();

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
      bottomNavigationBar: _createAddressButton(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30, left: 42, right: 42),
        height: height,
        width: width,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/create-address.webp'),
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              SizedBox(height: height * 0.035),
              _textFieldName(),
              SizedBox(height: height * 0.035),
              _textFieldDescription(),
              SizedBox(height: height * 0.035),
              _textFieldReferences(),
              SizedBox(height: height * 0.035),
              _locationButton(),
            ],
          ),
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
              'Añadir Dirección',
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

  Widget _textFieldName() {
    return TextField(
      controller: _controller.textFieldControllers['name'],
      autofocus: false,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Nombre De Dirección',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFC7C7C7), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFF525252), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return TextField(
      autofocus: false,
      textInputAction: TextInputAction.done,
      controller: _controller.textFieldControllers['description'],
      minLines: 3,
      maxLines: 3,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Dirección',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Dirección detallada',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFC7C7C7), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFF525252), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _textFieldReferences() {
    return TextField(
      autofocus: false,
      textInputAction: TextInputAction.done,
      controller: _controller.textFieldControllers['references'],
      minLines: 3,
      maxLines: 3,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Referencias',
        labelStyle: const TextStyle(color: Color(0XFF7e7e7e), fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Lugares conocidos o información importante',
        hintStyle: const TextStyle(color: Color(0XFF494949), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFC7C7C7), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFF525252), width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _locationButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      label: const Text(' Establecer ubicación', style: TextStyle(color: Colors.white)),
      icon: const Icon(FlutterIcons.location_arrow_faw, color: Colors.white, size: 18),
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        side: const BorderSide(style: BorderStyle.none),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    );
  }

  Widget _createAddressButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: _controller.createAddress,
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 40),
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
              const Text('Añadir', style: TextStyle(color: Colors.white)),
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Icon(FlutterIcons.edit_ent, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

}