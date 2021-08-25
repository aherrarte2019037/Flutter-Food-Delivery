import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/widgets/drawer/user_drawer.dart';

class DeliveryOrderListPage extends StatefulWidget {
  const DeliveryOrderListPage({Key? key}) : super(key: key);

  @override
  _DeliveryOrderListPageState createState() => _DeliveryOrderListPageState();
}

class _DeliveryOrderListPageState extends State<DeliveryOrderListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF496FD6),
        elevation: 0,
        leading: _buttonDrawer(),
      ),
      drawer: UserDrawer(drawerType: 'DELIVERY'),
      body: const Text('DELIVERY Order List')
    );
  }

  Widget _buttonDrawer() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: Scaffold.of(context).openDrawer,
          icon: const Icon(
            FlutterIcons.align_left_fea,
            color: Colors.white,
          ),
        );
      },
    );
  }
  
}
