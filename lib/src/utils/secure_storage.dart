import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_delivery/src/models/payment_card_model.dart';

class SecureStorage {
  static final _storage = const FlutterSecureStorage();

  static Future<void> addPaymentCard(PaymentCard card) async {
    List<PaymentCard> paymentCards = await getPaymentCards();
    paymentCards.insert(0, card);

    await _storage.write(key: 'paymentCards', value: jsonEncode(paymentCards));
  }

  static Future<List<PaymentCard>> getPaymentCards() async {
    String value = await _storage.read(key: 'paymentCards') ?? '[]';
    List<PaymentCard> paymentCards = PaymentCard.fromJsonList(jsonDecode(value));

    return paymentCards;
  }

  static Future<void> deleteAllPaymentCards() async {
    await _storage.deleteAll();
  }

}