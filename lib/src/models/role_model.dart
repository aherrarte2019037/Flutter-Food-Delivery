class Role {
  String name;
  String image;

  Role({
    required this.name,
    required this.image,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
  };
}
