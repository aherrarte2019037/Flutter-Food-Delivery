import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/pages/client/address/map/client_address_map_page.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {
  late BuildContext context;
  late Function updateView;
  Map<String, TextEditingController> textFieldControllers  = {
    'name': TextEditingController(),
    'address': TextEditingController(),
    'references': TextEditingController(),
  };
  Map? addressData; 

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void goBack() => Navigator.pop(context);

  void goToSelectAddress() async {
    addressData = await showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const ClientAddressMapPage(),
    );
    updateView();
  }

  void createAddress() {
    if(addressData == null) {
      CustomSnackBar.showError(context, 'Aviso', 'Establece tu ubicación');
    }

    for (var controller in textFieldControllers.values) {
      if(controller.text.isEmpty) {
        CustomSnackBar.showError(context, 'Aviso', 'Ingresa todos los datos');
        return;
      }
    }

    CustomSnackBar.showSuccess(context, 'Prueba', 'Dirección seleccionada');
    Logger().w(addressData);
  }

}