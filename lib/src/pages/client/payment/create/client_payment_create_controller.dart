import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/providers/address_provider.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';

class ClientPaymentCreateController {
  late BuildContext context;
  late Function updateView;
  Map<String, TextEditingController> textFieldControllers  = {
    'number' : TextEditingController(),
    'expDate': TextEditingController(),
    'cvv'    : TextEditingController(),
  };
  Address? address;
  List<Address> addressesCreated = [];
  AddressProvider addressProvider = AddressProvider();

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void goBack() => Navigator.pop(context, addressesCreated);

  void resetControllers() {
    for (var controller in textFieldControllers.values) {
      controller.text = '';
    }

    address = null;
  }
  
  void createAddress() async {
    for (var controller in textFieldControllers.values) {
      if(controller.text.isEmpty) {
        CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Ingresa todos los datos');
        return;
      }
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
      resetControllers();
      updateView();
      
    } else {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: responseApi!.message!);
    }
  }

}