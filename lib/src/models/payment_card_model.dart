import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';

enum PaymentCardType { debit, credit}

class PaymentCard {
  PaymentCardType type;
  int? number;
  DateTime? expirationDate;
  int? cvv;
  DateTime? createdAt;

  PaymentCard({
    required this.type,
    this.number,
    this.expirationDate,
    this.cvv,
    this.createdAt,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
    type          : EnumToString.fromString(PaymentCardType.values, json['type'] ?? 'PAGADO') ?? PaymentCardType.debit,
    number        : json['number'],
    expirationDate: json['expiryDate'] != null ? DateTime.parse(json['expirationDate']) : null,
    cvv           : json['cvv'],
    createdAt     : json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );

  static List<PaymentCard> fromJsonList(List json) => json.map((card) => PaymentCard.fromJson(card)).toList();

  Map<String, dynamic> toJson() => {
    'type'          : EnumToString.convertToString(type).toUpperCase(),
    'number'        : number,
    'expirationDate': expirationDate?.toIso8601String(),
    'cvv'           : cvv,
    'createdAt'     : createdAt?.toIso8601String(),
  };

  PaymentCard paymentMethodFromJson(String str) => PaymentCard.fromJson(json.decode(str));

  String paymentMethodToJson(PaymentCard paymentMethod) => json.encode(paymentMethod.toJson());

}