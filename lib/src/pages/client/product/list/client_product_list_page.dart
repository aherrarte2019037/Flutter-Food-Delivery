import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery/src/pages/client/product/list/client_product_list_controller.dart';

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
    return const Scaffold(
      body: Center(child: Text('CLIENT PRODUCT LIST PAGE')),
    );
  }
}

Widget userDrawer() {
  return Drawer(
    child: Container(
      color: const Color.fromRGBO(50, 75, 205, 1),
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [],
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildHeader({required String urlImage, required String email, required VoidCallback onClicked}) =>
  InkWell(
  onTap: onClicked,
    child: Container(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Row(
      children: [
        CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'asdasdasds',
                style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 24,
          backgroundColor: Color.fromRGBO(30, 60, 168, 1),
          child: Icon(Icons.add_comment_outlined, color: Colors.white),
        )
      ],
    ),
  ),
);
