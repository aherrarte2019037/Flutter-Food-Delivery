import 'package:flutter/cupertino.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/payment_card_model.dart';
import 'package:food_delivery/src/models/response_api_model.dart';
import 'package:food_delivery/src/providers/order_provider.dart';
import 'package:food_delivery/src/providers/user_provider.dart';
import 'package:food_delivery/src/utils/secure_storage.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';

class ClientPaymentListController {
  late BuildContext context;
  late Function updateView;
  late Address address;
  UserProvider userProvider = UserProvider();
  OrderProvider orderProvider = OrderProvider();
  List<PaymentCard> paymentCards = [];

  void init(BuildContext context, Function updateView, Address address) async {
    this.context = context;
    this.updateView = updateView;
    this.address = address;
    await SecureStorage.deleteAllPaymentCards();
    paymentCards = await SecureStorage.getPaymentCards();
  }

  void goBack() => Navigator.pop(context);

  void addPaymentMethod() {

  }

  Future<void> pay() async {
    ResponseApi? responseApi = await orderProvider.create(address.id!);
    if (responseApi?.success == false) {
      CustomSnackBar.showError(context: context, title: 'Error', message: 'Intenta otra vez');
      return;
    }
  }

}