import 'package:jiffy/jiffy.dart';
import 'package:neovision_flutter/service/models/recon.dart';

class Session {
  int id;
  String name;
  String description;
  DateTime startTime;
  double centerLat;
  double centerLng;
  String sessionMap;

  List<int> subordinatesIds;
  List<Recon> recons;

  Session({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.centerLat,
    required this.centerLng,
    required this.sessionMap,
    required this.subordinatesIds,
    required this.recons,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        startTime: Jiffy.parse(json["startTime"]).dateTime,
        centerLat: json["centerLat"],
        centerLng: json["centerLng"],
        sessionMap: json["sessionMap"],
        subordinatesIds: (json["subordinatesIds"] as List<dynamic>).cast<int>(),
        recons: (json["recons"] as List)
            .map((recon) => Recon.fromJson(recon))
            .toList(),
      );
}
