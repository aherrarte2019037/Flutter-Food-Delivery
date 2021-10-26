import 'package:flutter/cupertino.dart';

class ClientAddressMapController {
  late BuildContext context;
  late Function updateView;

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void goBack() => Navigator.pop(context);

}