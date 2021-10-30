import 'package:flutter/material.dart';
import 'package:food_delivery/src/utils/string_extension.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:food_delivery/src/widgets/address_item.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({Key? key}) : super(key: key);

  @override
  _ClientAddressListPageState createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  final _controller = ClientAddressListController();

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
      bottomNavigationBar: _controller.addresses.isNotEmpty ? _selectAddressButton() : null,
      body: Container(
        alignment: _controller.addresses.isNotEmpty ? Alignment.topCenter : Alignment.center,
        padding: const EdgeInsets.only(bottom: 30, left: 42, right: 42),
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: _controller.addresses.isNotEmpty ? 15 : 25),
                _controller.addresses.isNotEmpty ? _addressList() : _emptyAddressList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerImage() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage('assets/images/list-address.webp'),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _addressList() {
    return Column(
      children: [
        _bannerImage(),
        const SizedBox(height: 20),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _controller.addresses.length,
          separatorBuilder: (_, __) => _listSeparator(),
          itemBuilder: (_, index) => AddressItem(
            value: _controller.addresses[index].id,
            groupValue: _controller.addressSelected,
            name: _controller.addresses[index].name!.capitalize(),
            address: _controller.addresses[index].address!.titleCase(),
            onChanged: _controller.addressItemChanged(),
          ),
        ),
      ],
    );
  }

  Widget _listSeparator() {
    return Container(
      margin: const EdgeInsets.only(left: 22),
      height: 26,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              color: Color(0XFFFF8C3E),
              shape: BoxShape.circle,
            ),
          ),
          Transform.translate(
            offset: const Offset(-0.5, 0),
            child: Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(
                color: Color(0XFFFF8C3E),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              color: Color(0XFFFF8C3E),
              shape: BoxShape.circle,
            ),
          ),
        ],
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
              'Dirección de entrega',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: _controller.goToCreateAddress,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(2),
                shadowColor: Colors.transparent,
                elevation: 0,
                primary: Colors.white,
                onPrimary: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: const Icon(Icons.add_rounded, size: 30, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _emptyAddressList() {
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
            'No tienes direcciones',
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
                onPressed: _controller.goToCreateAddress,
                icon: const Icon(Icons.add_rounded),
                iconSize: 28,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectAddressButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42, left: 42, right: 42),
      child: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: _controller.selectAddress,
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