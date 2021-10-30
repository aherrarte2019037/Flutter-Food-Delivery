import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:food_delivery/src/models/address_model.dart';
import 'package:food_delivery/src/models/shopping_cart_model.dart';
import 'package:food_delivery/src/models/user_model.dart';

enum Status { pagado, despachado, enCamino, entregado  }

class Order {
  String? id;
  User? user;
  User? delivery;
  double? deliveryLatitude;
  double? deliveryLongitude;
  Address? address;
  ShoppingCart? cart;
  Status? status;
  DateTime? createdAt;

  Order({
    this.id,
    this.user,
    this.delivery,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.address,
    this.cart,
    this.status,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id               : json["_id"],
    user             : json["user"] != null ? User.fromJson(json["user"]) : null,
    delivery         : json["delivery"] != null ? User.fromJson(json["delivery"]) : null,
    deliveryLatitude : json["deliveryLatitude"].toDouble(),
    deliveryLongitude: json["deliveryLongitude"].toDouble(),
    address          : json["address"] != null ? Address.fromJson(json["address"]) : null,
    cart             : json["cart"] != null ? ShoppingCart.fromJson(json["cart"]) : null,
    status           : EnumToString.fromString(Status.values, json["status"] ?? 'pagado'),
    createdAt        : json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
  );

  static List<Order> fromJsonList(List json) => json.map((order) => Order.fromJson(order)).toList();

  Map<String, dynamic> toJson() => {
    "_id"              : id,
    "user"             : user,
    "delivery"         : delivery,
    "deliveryLatitude" : deliveryLatitude,
    "deliveryLongitude": deliveryLongitude,
    "address"          : address,
    "cart"             : cart,
    "status"           : status,
    "createdAt"        : createdAt?.toIso8601String(),
  };

  Order orderFromJson(String str) => Order.fromJson(json.decode(str));

  String orderToJson(Order data) => json.encode(data.toJson());
  
}