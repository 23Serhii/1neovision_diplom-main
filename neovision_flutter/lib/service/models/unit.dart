class Unit {
  int id;
  String name;
  String imageUrl;
  String modelUrl;
  bool downloaded = false;

  Unit({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.modelUrl,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        modelUrl: json["modelUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "modelUrl": modelUrl,
      };
}
