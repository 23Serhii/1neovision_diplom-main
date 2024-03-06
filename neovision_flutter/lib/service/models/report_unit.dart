import 'dart:typed_data';

class ReportUnit {
  int id;
  int unitId;
  String description;
  double latitude;
  double longitude;
  String name;
  List<String> unitPhotoUrls;
  List<Uint8List> photosToLoad = [];

  ReportUnit({
    required this.id,
    required this.unitId,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.name,
    required this.unitPhotoUrls,
  });

  factory ReportUnit.fromJson(Map<String, dynamic> json) => ReportUnit(
        id: json["id"],
        unitId: json["unitId"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        description: json["description"],
        unitPhotoUrls: (json["unitPhotoUrls"] as List)
            .map((unitPhotoUrl) => unitPhotoUrl.toString())
            .toList(),
        // cps: (json['cps'] as List).map((cpJson) => Cp.fromJson(cpJson)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "unitId": unitId,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
      };
}
