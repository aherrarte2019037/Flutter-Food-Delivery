import 'dart:convert';

class Product {
  String? id;
  String name;
  String description;
  int price;
  bool? available;
  List<String>? images;
  dynamic category;

  Product({
    required this.name,
    required this.description,
    required this.price,
    this.id,
    this.available,
    this.images,
    this.category,
  });


  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id         : json["_id"],
    name       : json["name"],
    description: json["description"],
    price      : json["price"],
    available  : json["available"],
    images     : List<String>.from(json["images"].map((x) => x)),
    category   : json["category"],
  );

  static List<Product> fromJsonList(List json) {
    return json.map((product) => Product.fromJson(product)).toList();
  }

  Map<String, dynamic> toJson() => {
    "_id"        : id,
    "name"       : name,
    "description": description,
    "price"      : price,
    "available"  : available,
    "images"     : images == null ? List<dynamic>.from(images!.map((x) => x)) : null,
    "category"   : category,
  };

  Product productFromJson(String str) => Product.fromJson(json.decode(str));

  String productToJson(Product data) => json.encode(data.toJson());
  
}
