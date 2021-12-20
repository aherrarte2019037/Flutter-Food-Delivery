import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/payment_card_model.dart';
import 'package:food_delivery/src/providers/address_provider.dart';
import 'package:food_delivery/src/utils/form_utils.dart';
import 'package:food_delivery/src/utils/secure_storage.dart';
import 'package:food_delivery/src/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class ClientPaymentCreateController {
  late BuildContext context;
  late Function updateView;
  Map<String, TextEditingController> textFieldControllers  = {
    'number'    : TextEditingController(),
    'expDate'   : TextEditingController(),
    'cvv'       : TextEditingController(),
    'cardHolder': TextEditingController(),
  };
  GlobalKey<FormState> keyForm = GlobalKey();
  Address? address;
  AddressProvider addressProvider = AddressProvider();

  void init(BuildContext context, Function updateView) {
    this.context = context;
    this.updateView = updateView;
  }

  void goBack() => Navigator.pop(context, null);
  
  void onPaymentCardChange(CreditCardModel paymentCard) {
    textFieldControllers['number']!.text = paymentCard.cardNumber;
    textFieldControllers['expDate']!.text = paymentCard.expiryDate;
    textFieldControllers['cvv']!.text = paymentCard.cvvCode;
    textFieldControllers['cardHolder']!.text = paymentCard.cvvCode;
    updateView();
  }

  Future<void> addPaymentCard() async {
    if (!FormUtils.formFilled(textFieldControllers)) {
      CustomSnackBar.showError(context: context, title: 'Aviso', message: 'Ingresa todos los datos');
      return;
    }

    DateFormat expDateFormat = DateFormat('MM/yy');
    DateTime expDate = expDateFormat.parse(textFieldControllers['expDate']!.text);

    PaymentCard paymentCard = PaymentCard(
      type: PaymentCardType.credit,
      number: int.parse(toNumericString(textFieldControllers['number']!.text.trim())),
      cvv: int.parse(textFieldControllers['cvv']!.text.trim()),
      cardHolder: textFieldControllers['cardHolder']!.text.trim(),
      expirationDate: expDate,
      createdAt: DateTime.now(),
    );
    await SecureStorage.addPaymentCard(paymentCard);
    FormUtils.resetForm(textFieldControllers);

    CustomSnackBar.showSuccess(context: context, title: 'Aviso', message: 'Tarjeta agregada');
    Navigator.pop(context, paymentCard);
  }

}