import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neovision_flutter/controllers/session_controller.dart';
import 'package:neovision_flutter/controllers/sessions_controller.dart';
import 'package:neovision_flutter/service/models/recon.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';
import 'package:neovision_flutter/service/models/session.dart';

class ReconController extends GetxController {
  SessionsController sessionsController = Get.find();
  late SessionController sessionController;

  Rx<bool> loading = true.obs;
  Rx<bool> selected = false.obs;
  late Rx<Session> session;
  Rx<List<ReportUnit>> reportUnits = Rx<List<ReportUnit>>([]);

  TextEditingController reportEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (sessionsController.sessions.value.isNotEmpty) {
      if (Get.arguments == null) {
        session = sessionsController.sessions.value.first.obs;
      } else {
        sessionController = Get.find();
        session = (Get.arguments as Session).obs;
      }
    }
    loading.value = false;
  }

  void saveReportUnit(
    int unitId,
    String name,
    List<Uint8List> photos,
    LatLng position,
  ) {
    ReportUnit newReportUnit = ReportUnit(
      id: reportUnits.value.length,
      name: name,
      unitId: unitId,
      latitude: position.latitude,
      longitude: position.longitude,
      description: "",
      unitPhotoUrls: [],
    );
    newReportUnit.photosToLoad = photos;
    reportUnits.value = [
      ...reportUnits.value,
      newReportUnit,
    ];
    Get.back();
  }

  void deleteReportUnit(ReportUnit reportUnit) {
    reportUnits.update((val) {
      val?.removeWhere((element) => element.id == reportUnit.id);
    });
  }

  void saveReportUnitDescription(ReportUnit reportUnit, String description) {
    int index =
        reportUnits.value.indexWhere((element) => element.id == reportUnit.id);
    reportUnits.update((val) {
      val?[index].description = description;
    });
    Get.back();
  }

  void saveRecon() async {
    if (reportEditingController.text.isEmpty) {
      Get.snackbar("Помилка", "Заповніть опис");
    } else if (reportUnits.value.isEmpty) {
      Get.snackbar("Помилка", "Додайте хоча б одно бойову одиницю");
    } else {
      var reconData = await sessionsController.mainController.neoApi
          .createRecon(
              reportEditingController.text,
              sessionsController.mainController.client.value.id,
              session.value.id,
              reportUnits.value);
      // await sessionsController.mainController.updateSessions();

      Recon recon = Recon.fromJson(reconData);
      if (Get.arguments != null) {
        sessionController.session.update((val) {
          if (val != null) {
            val.recons = [...val.recons, recon];
          }
        });
      } else {
        int sessionIndex = sessionsController.sessions.value
            .indexWhere((element) => element.id == session.value.id);
        sessionsController.sessions.value[sessionIndex].recons.add(recon);
      }

      Get.back();
    }
  }
}
