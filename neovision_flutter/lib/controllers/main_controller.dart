import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/pages/auth_page.dart';
import 'package:neovision_flutter/pages/home_page.dart';
import 'package:neovision_flutter/service/models/client.dart';
import 'package:neovision_flutter/service/neo_api.dart';

class MainController extends GetxController {
  NeoApi neoApi = NeoApi();
  final storage = const FlutterSecureStorage();
  var initProfileLoading = true.obs;
  late Rx<Client> client;
  var currentLocation;
  var locationTimer;
  late StreamSubscription locationStream;
  late Function updateSessions;

  @override
  void onInit() {
    super.onInit();
    initProfile();
    requestLocation();
  }

  requestLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {}
    }
    LocationSettings locationSettings =
        LocationSettings(accuracy: LocationAccuracy.best);
    locationStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) async {
        currentLocation = position.obs;
      },
      onError: (error) {
        checkLocation();
        locationStream.cancel();
      },
      cancelOnError: false,
    );
  }

  checkLocation() async {
    locationTimer = Timer.periodic(Duration(seconds: 2), (Timer t) async {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
      } else {
        t.cancel();
        requestLocation();
      }
    });
  }

  void initProfile() async {
    var token = await storage.read(key: "token");
    if (token != null) {
      neoApi.setApiKey(token);
      client = Client.fromJson(await neoApi.getInfo()).obs;
      Get.offAllNamed(HomePage.id);
    }
  }

  void logout() {
    storage.deleteAll();
    neoApi.setApiKey("");
    Get.offAllNamed(AuthPage.id);
  }
}
