import 'dart:convert';

class ProductCategory {
  String? id;
  String? name;
  String? description;
  String? image;
  DateTime? createdAt;

  ProductCategory({
    this.name,
    this.description,
    this.image,
    this.id,
    this.createdAt
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    name: json["name"],
    description: json["description"],
    image: json["image"],
    id       : json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  static List<ProductCategory> fromJsonList(List json) {
    return json.map((category) => ProductCategory.fromJson(category)).toList();
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "image": image,
    "_id"       : id,
    "createdAt": createdAt?.toIso8601String(),
  };
  
  ProductCategory productCategoryFromJson(String str) => ProductCategory.fromJson(json.decode(str));

  String productCategoryToJson(ProductCategory data) => json.encode(data.toJson());

}
