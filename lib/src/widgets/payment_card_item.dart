import 'package:flutter/material.dart';
import 'package:food_delivery/src/models/payment_card_model.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class PaymentCardItem<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final PaymentCard card;
  final ValueChanged<T?> onChanged;

  const PaymentCardItem({
    required this.value,
    required this.groupValue,
    required this.card,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Map<CreditCardType, Map> cardTypeImage = {
      CreditCardType.visa: { 'image': 'assets/images/visa-logo.png', 'height': 45 },
      CreditCardType.mastercard: { 'image': 'assets/images/mastercard-logo.png', 'height': 34 },
      CreditCardType.amex: { 'image': 'assets/images/amex-logo.png', 'height': 42 },
      CreditCardType.discover: { 'image': 'assets/images/discover-logo.png', 'height': 50 },
      CreditCardType.dinersclub: { 'image': 'assets/images/diners-club-logo.png', 'height': 42 },
      CreditCardType.unknown: { 'image': 'assets/images/card-icon.png', 'height': 30 },
    };
    final String image = cardTypeImage[detectCCType(card.number.toString())]?['image'] ?? 'assets/images/card-icon.png';
    final num height = cardTypeImage[detectCCType(card.number.toString())]?['height'] ?? 30;

    return Container(
      width: double.infinity,
      height: 85,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0XFFF4F5F7),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 85,
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0XFFF4F5F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              image,
              height: height.toDouble(),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.type == PaymentCardType.cash ? 'Efectivo' : card.numberWithMask,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF4f5669),
                ),
              ),
              Text(
                card.type == PaymentCardType.cash ? 'Pago contra entrega' : 'Expira el ${card.expFormatted}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFF969CAB),
                ),
              ),
            ],
          ),
          const Spacer(),
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: const Color(0XFFFF8C3E),
          ),
        ],
      ),
    );
  }

}