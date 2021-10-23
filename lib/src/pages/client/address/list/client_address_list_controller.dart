import 'package:flutter/cupertino.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function updateView;
  List addressList = [];

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void goBack() => Navigator.pop(context);

  void goToCreateAddress() => Navigator.pushNamed(context, 'client/address/create');

}