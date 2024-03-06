import 'package:jiffy/jiffy.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';

class Recon {
  int id;
  String report;
  String creatorName;
  DateTime timestamp;
  List<ReportUnit> reportUnits;

  Recon({
    required this.id,
    required this.report,
    required this.timestamp,
    required this.creatorName,
    required this.reportUnits,
  });

  factory Recon.fromJson(Map<String, dynamic> json) => Recon(
        id: json["id"],
        report: json["report"],
        timestamp: Jiffy.parse(json["timestamp"]).dateTime,
        creatorName: json["creatorName"],
        reportUnits: (json["reportUnits"] as List)
            .map((reportUnit) => ReportUnit.fromJson(reportUnit))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "report": report,
        "timestamp": timestamp,
        "createdBy": creatorName,
        "reportUnits": reportUnits,
      };
}
