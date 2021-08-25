import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:food_delivery/src/pages/client/product/list/client_product_list_controller.dart';
import 'package:food_delivery/src/widgets/drawer/user_drawer.dart';

class ClientProductListPage extends StatefulWidget {
  const ClientProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ClientProductListPage> {
  final ClientProductListController _productListController = ClientProductListController();

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _productListController.init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF496FD6),
        elevation: 0,
        leading: _buttonDrawer(),
      ),
      drawer: UserDrawer(drawerType: 'CLIENT'),
      body: const Text('Client Product List')
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
