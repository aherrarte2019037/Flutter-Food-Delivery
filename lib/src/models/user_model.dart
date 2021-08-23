import 'dart:convert';
import 'package:food_delivery/src/models/role_model.dart';

class User {
  String email;
  String password;
  String firstName;
  String lastName;
  String? image;
  List<Role>? roles;

  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.image,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email    : json["email"],
    password : json["password"],
    firstName: json["firstName"],
    lastName : json["lastName"],
    image    : json["image"],
    roles    : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "email"    : email,
    "password" : password,
    "firstName": firstName,
    "lastName" : lastName,
    "image"    : image,
    "roles"    : roles != null ? List<dynamic>.from(roles!.map((x) => x.toJson())): null
  };

  User userFromJson(String str) => User.fromJson(json.decode(str));

  String userToJson(User data) => json.encode(data.toJson());
}
