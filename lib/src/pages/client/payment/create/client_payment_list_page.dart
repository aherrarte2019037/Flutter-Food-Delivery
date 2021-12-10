import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/pages/client/payment/create/client_payment_list_controller.dart';

class ClientPaymentListPage extends StatefulWidget {
  const ClientPaymentListPage({ Key? key }) : super(key: key);

  @override
  _ClientPaymentListPageState createState() => _ClientPaymentListPageState();
}

class _ClientPaymentListPageState extends State<ClientPaymentListPage> {
  final _controller = ClientPaymentListController();

  void updateView() => setState(() => {});

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      Address address = ModalRoute.of(context)?.settings.arguments as Address;
      _controller.init(context, updateView, address);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      bottomNavigationBar: _controller.paymentCards.isNotEmpty ? _payButton() : null,
      body: Container(
        alignment: _controller.paymentCards.isNotEmpty ? Alignment.topCenter : Alignment.center,
        padding: const EdgeInsets.only(left: 42, right: 42),
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: _controller.paymentCards.isNotEmpty ? 15 : 25),
                _controller.paymentCards.isNotEmpty ? Container() : _emptyPaymentList(),
              ],
            ),
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
              child: const Icon(Icons.arrow_back_rounded, size: 30, color: Colors.black),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(2),
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            const Text(
              'Método de pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: _controller.addPaymentMethod,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                shadowColor: Colors.transparent,
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: const Icon(Icons.add_rounded, size: 32, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyPaymentList() {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 240,
            child: Image.asset(
              'assets/images/empty-address.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'No tienes métodos de pago',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0XFF0C0C0C)),
          ),
          const SizedBox(height: 20),
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.24),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Ink(
              decoration: const ShapeDecoration(color: Colors.black, shape: CircleBorder()),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                iconSize: 28,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _payButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: _controller.pay,
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
              const Text('Seleccionar', style: TextStyle(color: Colors.white)),
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Icon(FlutterIcons.md_checkmark_ion, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

}