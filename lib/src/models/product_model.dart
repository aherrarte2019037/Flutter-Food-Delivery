import 'dart:convert';

class Product {
  String? id;
  String name;
  String description;
  int price;
  int calories;
  bool? available;
  List<String>? images;
  dynamic category;
  DateTime? createdAt;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.calories,
    this.id,
    this.available,
    this.images,
    this.category,
    this.createdAt
  });


  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id         : json["_id"],
    name       : json["name"],
    description: json["description"],
    price      : json["price"],
    calories   : json["calories"],
    available  : json["available"],
    images     : json["images"] != null ? List<String>.from(json["images"].map((x) => x)) : null,
    category   : json["category"],
    createdAt  : json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
  );

  static List<Product> fromJsonList(List json) => json.map((product) => Product.fromJson(product)).toList();

  Map<String, dynamic> toJson() => {
    "_id"        : id,
    "name"       : name,
    "description": description,
    "price"      : price,
    "calories"   : calories,
    "available"  : available,
    "images"     : images != null ? List<dynamic>.from(images!.map((x) => x)) : null,
    "category"   : category,
    "createdAt": createdAt?.toIso8601String(),
  };

  Product productFromJson(String str) => Product.fromJson(json.decode(str));

  String productToJson(Product data) => json.encode(data.toJson());
  
}
