// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';
import 'package:neovision_flutter/service/models/unit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class SessionShowArPage extends StatefulWidget {
  static String id = "/session_show_ar";
  final List<ReportUnit> reportUnits;
  const SessionShowArPage({super.key, required this.reportUnits});

  @override
  _SessionShowArPageState createState() => _SessionShowArPageState();
}

class _SessionShowArPageState extends State<SessionShowArPage> {
  //**** Контроллери ****
  late ARKitController arkitController;
  MainController mainController = Get.find();
  List<Unit> units = [];
  // late var controller;

  void loadUnits() async {
    setState(() {
      units.clear();
    });
    for (var unit in (await mainController.neoApi.getUnits() as List)) {
      setState(() {
        units.add(Unit.fromJson(unit));
      });
    }
    initializeArObjects();
  }

  bool arLoading = false;

  Future<String> _downloadAndStoreModel(String url) async {
    setState(() {
      arLoading = true;
    });
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/model.usdz');
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        arLoading = false;
      });
      return file.path;
    } else {
      return "";
    }
  }

  void initializeArObjects() {
    for (var reportUnit in widget.reportUnits) {
      // Розрахунок позиції AR-об'єкта
      var arPosition =
          calculateArPosition(reportUnit.latitude, reportUnit.longitude);

      // Додавання AR-об'єкта у сцену
      addArObject(
          units
              .firstWhere((element) => element.id == reportUnit.unitId)
              .modelUrl,
          arPosition);
    }
  }

  void addArObject(String modelUrl, vector.Vector3 position) async {
    // Спочатку завантажуємо і зберігаємо модель
    String modelPath = await _downloadAndStoreModel(modelUrl);
    if (modelPath.isNotEmpty) {
      // Створюємо ARKitReferenceNode з завантаженою моделлю
      var newNode = ARKitReferenceNode(
        url: modelPath,
        scale: vector.Vector3.all(0.1), // Масштаб можна налаштувати
        position: position,
      );

      // Додавання вузла до ARKitController
      arkitController.add(newNode);
    } else {
      // Обробка помилки, якщо модель не була завантажена
      print("Помилка завантаження моделі");
    }
  }

  @override
  void dispose() {
    try {
      arkitController.dispose();
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ARKitSceneView(
              onARKitViewCreated: onARKitViewCreated,
              planeDetection: ARPlaneDetection.horizontal,
            ),
            Visibility(
              visible: arLoading,
              child: const Positioned(
                child: Text("LOADING"),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Material(
                color: Colors.transparent,
                child: SafeArea(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: WHITE_TRANSPARENT,
                      child: SvgPicture.asset(
                        "assets/icons/arrow_back_icon.svg",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    loadUnits();
  }

  vector.Vector3 calculateArPosition(
      double targetLatitude, double targetLongitude) {
    // Припустимо, що currentLatitude та currentLongitude - це поточні координати користувача
    double currentLatitude = mainController.currentLocation.value.latitude;
    double currentLongitude = mainController.currentLocation.value.longitude;

    // Розрахунок відстані та напрямку
    double distance = calculateDistance(
        currentLatitude, currentLongitude, targetLatitude, targetLongitude);
    print("distance $distance");
    double bearing = calculateBearing(
        currentLatitude, currentLongitude, targetLatitude, targetLongitude);

    // Перетворення в локальні координати (приклад)
    // Ви можете змінити цей масштаб, щоб відповідати вашій AR-сцені
    double scale = 0.1; // Масштабування географічної відстані до AR-відстані
    double x = distance * math.cos(bearing);
    double z = distance * math.sin(bearing);

    return vector.Vector3(
        x, 0, z); // y-координата залишається 0, якщо ви не враховуєте висоту
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Math.PI / 180
    var a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km
  }

  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    var dLon = (lon2 - lon1).toRadians();
    var y = math.sin(dLon) * math.cos(lat2.toRadians());
    var x = math.cos(lat1.toRadians()) * math.sin(lat2.toRadians()) -
        math.sin(lat1.toRadians()) *
            math.cos(lat2.toRadians()) *
            math.cos(dLon);
    return math.atan2(y, x);
  }
}

extension on double {
  double toRadians() => this * math.pi / 180.0;
}
