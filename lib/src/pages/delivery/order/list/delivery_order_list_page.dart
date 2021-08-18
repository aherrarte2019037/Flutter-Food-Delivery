import 'package:flutter/material.dart';

class DeliveryOrderListPage extends StatefulWidget {
  const DeliveryOrderListPage({Key? key}) : super(key: key);

  @override
  _DeliveryOrderListPageState createState() => _DeliveryOrderListPageState();
}

class _DeliveryOrderListPageState extends State<DeliveryOrderListPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('DELIVERY ORDER LIST PAGE'),
      ),
    );
  }
}
