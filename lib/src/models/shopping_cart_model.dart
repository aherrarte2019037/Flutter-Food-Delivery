import 'dart:convert';
import 'package:food_delivery/src/models/shopping_cart_item_model.dart';

class ShoppingCart {
  dynamic user;
  int subTotal;
  int total;
  List<ShoppingCartItem>? products;
  String? id;
  DateTime? createdAt;

  ShoppingCart({
    required this.subTotal,
    required this.total, 
    this.id,
    this.products,
    this.createdAt,
    this.user
  });

  factory ShoppingCart.fromJson(Map<String, dynamic> json) => ShoppingCart(
    user     : json["user"],
    subTotal : json["subTotal"],
    total    : json["total"],
    id       : json["_id"],
    products : json["products"].isNotEmpty ? List.from(json["products"].map((x) => ShoppingCartItem.fromJson(x))) : null,
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "user"     : user,
    "subTotal" : subTotal,
    "total"    : total,
    "_id"      : id,
    "products" : products != null ? List<dynamic>.from(products!.map((x) => jsonEncode(x))): null,
    "createdAt": createdAt?.toIso8601String(),
  };

  ShoppingCart shoppingCartFromJson(String str) => ShoppingCart.fromJson(json.decode(str));

  String shoppingCartToJson(ShoppingCart data) => json.encode(data.toJson());
}