import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/pages/client/address/map/map_page.dart';
import 'package:food_delivery/src/providers/address_provider.dart';
import 'package:food_delivery/src/utils/form_utils.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {
  late BuildContext context;
  late Function updateView;
  Map<String, TextEditingController> textFieldControllers  = {
    'name': TextEditingController(),
    'address': TextEditingController(),
    'references': TextEditingController(),
  };
  Address? address;
  List<Address> addressesCreated = [];
  AddressProvider addressProvider = AddressProvider();

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void goBack() => Navigator.pop(context, addressesCreated);

  void goToSelectAddress() async {
    address = await showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const MapPage(),
    );
    updateView();
  }
  
  void createAddress() async {
    if (!FormUtils.formFilled(textFieldControllers)) {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Ingresa todos los datos');
      return;
    }

    if(address == null) {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Establece tu ubicación');
      return;
    }

    address!.name = textFieldControllers['name']!.text.trim();
    address!.address = textFieldControllers['address']!.text.trim();
    address!.references = textFieldControllers['references']!.text.trim();

    ResponseApi? responseApi = await addressProvider.create(address!);
    if (responseApi?.success == true) {
      addressesCreated.insert(0, responseApi!.data as Address);
      CustomSnackBar.showSuccess(context: context, title: 'Aviso', message: 'Dirección de entrega creada');
      
      FormUtils.resetForm(textFieldControllers);
      address = null;

      updateView();
      
    } else {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: responseApi!.message!);
    }
  }

}