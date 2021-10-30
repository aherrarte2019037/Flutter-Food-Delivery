import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/order_model.dart';
import 'package:food_delivery/src/providers/address_provider.dart';
import 'package:food_delivery/src/providers/order_provider.dart';
import 'package:logger/logger.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function updateView;
  AddressProvider addressProvider = AddressProvider();
  OrderProvider orderProvider = OrderProvider();
  List<Address> addresses = [];
  String? addressSelected = '';

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
    getAddressList();
  }

  void getAddressList() async {
    addresses = await addressProvider.getAllByUser();
    if (addresses.isNotEmpty) addressSelected = addresses[0].id;
    updateView();
  }

  ValueChanged addressItemChanged() {
    return (value) {
      addressSelected = value!;
      updateView();
    };
  }

  void goBack() => Navigator.pop(context);

  void goToCreateAddress() async {
    List<Address> addressesCreated = await Navigator.pushNamed(context, 'client/address/create') as List<Address>;
    addresses.insertAll(0, addressesCreated);
    if (addresses.isNotEmpty) addressSelected = addresses[0].id;
    updateView();
  }

  Future createOrder() async {
    Address address = addresses.firstWhere((element) => element.id == addressSelected);
    Order? order = await orderProvider.create(address);
    Logger().d(order);
  }

}