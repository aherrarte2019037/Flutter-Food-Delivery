import 'package:flutter/cupertino.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function updateView;
  List addressList = [];
  String? addressSelected = '1';

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  ValueChanged addressItemChanged() {
    return (value) {
      addressSelected = value!;
      updateView();
    };
  }

  void goBack() => Navigator.pop(context);

  void goToCreateAddress() => Navigator.pushNamed(context, 'client/address/create');

}