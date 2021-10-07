import 'dart:convert';
import 'package:food_delivery/src/models/product_model.dart';

class ShoppingCartItem {
  int quantity;
  Product product;

  ShoppingCartItem({
    required this.quantity,
    required this.product, 
  });

  factory ShoppingCartItem.fromJson(Map<String, dynamic> json) => ShoppingCartItem(
    quantity: json["quantity"],
    product : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "product" : product,
  };

  static List<ShoppingCartItem> fromJsonList(List json) => json.map((item) => ShoppingCartItem.fromJson(item)).toList();

  ShoppingCartItem shoppingCartItemFromJson(String str) => ShoppingCartItem.fromJson(json.decode(str));

  String shoppingCartItemToJson(ShoppingCartItem data) => json.encode(data.toJson());
}