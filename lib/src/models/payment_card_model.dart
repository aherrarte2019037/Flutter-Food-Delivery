import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';

enum PaymentCardType { debit, credit, cash }

class PaymentCard {
  PaymentCardType type;
  int? number;
  DateTime? expirationDate;
  int? cvv;
  DateTime? createdAt;
  String? cardHolder;

  PaymentCard({
    required this.type,
    this.number,
    this.expirationDate,
    this.cvv,
    this.createdAt,
    this.cardHolder,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
    type          : EnumToString.fromString(PaymentCardType.values, json['type'] ?? 'PAGADO') ?? PaymentCardType.debit,
    number        : json['number'],
    cardHolder    : json['cardHolder'],
    expirationDate: json['expiryDate'] != null ? DateTime.parse(json['expirationDate']) : null,
    cvv           : json['cvv'],
    createdAt     : json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );

  static List<PaymentCard> fromJsonList(List json) => json.map((card) => PaymentCard.fromJson(card)).toList();

  Map<String, dynamic> toJson() => {
    'type'          : EnumToString.convertToString(type).toUpperCase(),
    'number'        : number,
    'cardHolder'    : cardHolder,
    'expirationDate': expirationDate?.toIso8601String(),
    'cvv'           : cvv,
    'createdAt'     : createdAt?.toIso8601String(),
  };

  PaymentCard paymentMethodFromJson(String str) => PaymentCard.fromJson(json.decode(str));

  String paymentMethodToJson(PaymentCard paymentMethod) => json.encode(paymentMethod.toJson());

  String get numberWithMask {
    if (type == PaymentCardType.cash) return '';
    return 'xxxxxx ${number.toString().substring(number.toString().length - 4)}';
  }

  String get expFormatted {
    if (type == PaymentCardType.cash) return '';
    return '${expirationDate?.month}/${expirationDate?.year}';
  }

}