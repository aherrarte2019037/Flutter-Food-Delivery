import 'dart:convert';

class Address {
  String? id;
  String? name;
  String? references;
  DateTime? createdAt;
  String? address;
  double latitude;
  double longitude;

  Address({
    this.id,
    this.name,
    this.references,
    this.createdAt,
    this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id        : json["_id"],
    name      : json["name"],
    references: json["references"],
    createdAt : json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    address   : json["address"],
    latitude  : json["latitude"],
    longitude : json["longitude"],
  );

  static List<Address> fromJsonList(List json) => json.map((address) => Address.fromJson(address)).toList();

  Map<String, dynamic> toJson() => {
    "_id"       : id,
    "name"      : name,
    "references": references,
    "createdAt" : createdAt?.toIso8601String(),
    "address"   : address,
    "latitude"  : latitude,
    "longitude" : longitude,
  };

  Address addressFromJson(String str) => Address.fromJson(json.decode(str));

  String addressToJson(Address data) => json.encode(data.toJson());
  
}