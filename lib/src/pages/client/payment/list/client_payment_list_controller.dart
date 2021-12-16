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
  List<PaymentCard> paymentCards = [
    PaymentCard(
      type: PaymentCardType.cash,
      cvv: 0,
      number: 0,
      createdAt: DateTime.now(),
      expirationDate: DateTime.now(),
    ),
  ];
  String paymentCardSelected = '';

  void init(BuildContext context, Function updateView, Address address) async {
    this.context = context;
    this.updateView = updateView;
    this.address = address;
    await SecureStorage.deleteAllPaymentCards();
    paymentCards.addAll(await SecureStorage.getPaymentCards());
    paymentCardSelected = paymentCards[0].createdAt.toString();
    updateView();
  }

  void goBack() => Navigator.pop(context);

  Future<void> addPaymentCard() async {
    await Navigator.pushNamed(context, 'client/payment/create');
  }

  ValueChanged paymentCardItemChanged() {
    return (value) {
      paymentCardSelected = value!.toString();
      updateView();
    };
  }

  Future<void> pay() async {
    ResponseApi? responseApi = await orderProvider.create(address.id!);
    if (responseApi?.success == false) {
      CustomSnackBar.showError(context: context, title: 'Error', message: 'Intenta otra vez');
      return;
    }
  }

}