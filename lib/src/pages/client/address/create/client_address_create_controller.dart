import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/pages/client/address/map/client_address_map_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

  void goToSelectAddress() {
    showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const ClientAddressMapPage(),
    );
  }

  void createAddress() {
    
  }

}