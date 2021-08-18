import 'package:flutter/material.dart';

class RestaurantOrderListPage extends StatefulWidget {
  const RestaurantOrderListPage({Key? key}) : super(key: key);

  @override
  _DelivRestaurantListPageState createState() => _DelivRestaurantListPageState();
}

class _DelivRestaurantListPageState extends State<RestaurantOrderListPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('RESTAURANT ORDER LIST PAGE'),
      ),
    );
  }
}