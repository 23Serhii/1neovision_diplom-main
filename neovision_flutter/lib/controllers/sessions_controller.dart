import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/service/models/session.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SessionsController extends GetxController {
  MainController mainController = Get.find();
  Rx<List<Session>> sessions = Rx<List<Session>>([]);
  Rx<bool> loadingSessions = true.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  //NEW SESSION
  Uint8List? mapBytes;
  Rx<String> mapUrl = "".obs;
  Rx<bool> showMap = false.obs;
  Rx<int> countSubordinates = 0.obs;
  Rx<bool> mapLoading = false.obs;
  LatLng squarePosition = const LatLng(0.0, 0.0);
  Rx<List<int>> newSubordinatesIds = Rx<List<int>>([]);
  TextEditingController newNameEditingController = TextEditingController();
  TextEditingController newDescriptionEditingController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadSessions();
    mainController.updateSessions = loadSessions;
  }

  onRefresh() {
    loadSessions();
    refreshController.refreshCompleted();
  }

  onLoading() {
    loadSessions();
    refreshController.loadComplete();
  }

  loadSessions() async {
    loadingSessions.value = true;
    sessions.value.clear();
    for (var session in (await mainController.neoApi.getSessions() as List)) {
      sessions.value.add(Session.fromJson(session));
    }
    loadingSessions.value = false;
  }

  setSquareCenter(LatLng newCenter) async {
    Get.back();
    mapLoading.value = true;
    squarePosition = newCenter;
    String imageUrl = 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=${squarePosition.latitude},${squarePosition.longitude}'
        '&maptype=satellite'
        '&zoom=16'
        '&size=2000x2000'
        '&key=AIzaSyAbyadqDovF_ZvTsPJG4bd9IxD50JEzpQs';
    try {
      final response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        mapUrl.value = imageUrl;
        showMap.value = true;
      } else {
        showMap.value = false;
      }
    } catch (e) {
      showMap.value = false;
    }
    try {
      final response = await http.get(Uri.parse(imageUrl));
      mapBytes = response.bodyBytes;
    } catch (e) {
      print(e);
    }
    mapLoading.value = false;
  }

  createSession() async {
    if (newDescriptionEditingController.text.isEmpty ||
        newNameEditingController.text.isEmpty ||
        // newSubordinatesIds.value.isEmpty ||
        (squarePosition.latitude == 0.0 && squarePosition.longitude == 0.0)) {
      Get.snackbar("Помилка", "Заповніть всі поля");
    } else {
      await mainController.neoApi.createSession(
        newNameEditingController.text,
        newDescriptionEditingController.text,
        newSubordinatesIds.value,
        squarePosition,
        mapBytes,
      );
      clear();
      Get.back();
      loadSessions();
    }
  }

  clear() {
    newSubordinatesIds.value.clear();
    newDescriptionEditingController.clear();
    newNameEditingController.clear();
    showMap.value = false;
    mapUrl.value = "";
    mapBytes = null;
    countSubordinates = 0.obs;
  }
}
