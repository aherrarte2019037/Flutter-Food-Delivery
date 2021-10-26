import 'package:flutter/cupertino.dart';

class ClientAddressCreateController {
  late BuildContext context;
  late Function updateView;
  Map<String, TextEditingController> textFieldControllers  = {
    'name': TextEditingController(),
    'address': TextEditingController(),
    'references': TextEditingController(),
  };

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void goBack() => Navigator.pop(context);

  void createAddress() {
    
  }

}