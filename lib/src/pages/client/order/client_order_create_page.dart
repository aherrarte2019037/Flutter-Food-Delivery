import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_delivery/src/pages/client/order/client_order_create_controller.dart';

class ClientOrderCreatePage extends StatefulWidget {
  const ClientOrderCreatePage({Key? key}) : super(key: key);

  @override
  _ClientOrderCreatePageState createState() => _ClientOrderCreatePageState();
}

class _ClientOrderCreatePageState extends State<ClientOrderCreatePage> {
  final _controller = ClientOrderCreateController();

  updateView() => setState(() => {});

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, updateView);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Client Order Create Page'),
      ),
    );
  }
  
}