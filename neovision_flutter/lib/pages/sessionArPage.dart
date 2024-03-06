// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/functions.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/controllers/recon_controller.dart';
import 'package:neovision_flutter/controllers/session_controller.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/dialog/photo_dialog.dart';
import 'package:neovision_flutter/pages/dialog/remove_unit_dialog.dart';
import 'package:neovision_flutter/service/models/role.dart';
import 'package:neovision_flutter/service/models/unit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class SessionArPage extends StatefulWidget {
  static String id = "/session_ar";

  const SessionArPage({super.key});

  @override
  _SessionArPageState createState() => _SessionArPageState();
}

class _SessionArPageState extends State<SessionArPage> {
  //**** Контроллери ****
  late ARKitController arkitController;
  MainController mainController = Get.find();
  late var controller;

  //**** Зміни для AR ****
  var localImagePath;
  String? localModelPath;
  ARKitNode? placedMap;
  ARKitNode? placedUnit;
  List<Unit> units = [];
  int selectedUnit = -1;

  //**** Зміни для стану віджетів ****
  bool isRecording = false;
  bool capturingScreen = false;
  late bool isCommander;

  //зміни контейнера
  double newContainerHeight = 0;
  double previousContainerHeight = 0;
  bool fullHeight = false;

  //**** Зміни для збереження UnitReport ****
  List<Uint8List> unitPhotos = [];

  @override
  void initState() {
    super.initState();
    loadUnits();
    setState(() {
      isCommander = mainController.client.value.role == Role.commander;
    });
    if (isCommander) {
      controller = Get.find<SessionController>();
      _downloadAndStoreImage(controller.session.value.sessionMap);
    } else {
      controller = Get.find<ReconController>();
    }
  }

  void loadUnits() async {
    setState(() {
      units.clear();
    });
    for (var unit in (await mainController.neoApi.getUnits() as List)) {
      setState(() {
        units.add(Unit.fromJson(unit));
      });
    }
    setState(() {
      selectedUnit = 0;
    });
  }

  Future<void> _downloadAndStoreImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getTemporaryDirectory();
    final file = File('${documentDirectory.path}/temp_image.jpg');
    file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      localImagePath = file.path;
    });
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
            false
                ? Container(
                    color: BG_COLOR,
                  )
                : ARKitSceneView(
                    onARKitViewCreated: onARKitViewCreated,
                    enableTapRecognizer: true,
                    enablePinchRecognizer: true,
                    enablePanRecognizer: true,
                    enableRotationRecognizer: true,
                    showFeaturePoints: true,
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
            Positioned(
              top: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: SafeArea(
                  child: InkWell(
                    onTap: capturingScreen
                        ? null
                        : () async {
                            setState(() {
                              capturingScreen = true;
                            });
                            try {
                              final ImageProvider imageProvider =
                                  await arkitController.snapshot();
                              Uint8List arPhoto =
                                  await getCompressedUint8ListFromImageProvider(
                                      imageProvider);
                              Get.dialog(
                                PhotoDialog(
                                    photo: arPhoto,
                                    text: isCommander
                                        ? "Зберегти в галерею?"
                                        : "Додати до доповіді?",
                                    onAccept: isCommander
                                        ? () async {
                                            try {
                                              await ImageGallerySaver.saveImage(
                                                  arPhoto,
                                                  name:
                                                      "arPhoto_${DateTime.now().toString()}");
                                              Get.back();
                                            } catch (e) {
                                              print(e);
                                              Get.snackbar("Помилка",
                                                  "Фото не завантажено");
                                            }
                                          }
                                        : () {
                                            unitPhotos.add(arPhoto);
                                            Get.back();
                                          }),
                              );
                            } catch (e) {
                              print(e);
                              Get.snackbar("Помилка", "Помилка фотографування");
                            }
                            setState(() {
                              capturingScreen = false;
                            });
                          },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: WHITE_TRANSPARENT,
                      child: SvgPicture.asset(
                        "assets/icons/camera_icon.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                        height: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: 100,
            //   right: 20,
            //   child: Material(
            //     color: Colors.transparent,
            //     child: SafeArea(
            //       child: InkWell(
            //         onTap: () {},
            //         child: CircleAvatar(
            //           radius: 30.0,
            //           backgroundColor: WHITE_TRANSPARENT,
            //           child: isRecording
            //               ? Container(
            //                   color: Colors.redAccent,
            //                   height: 25,
            //                   width: 25,
            //                 )
            //               : const CircleAvatar(
            //                   backgroundColor: Colors.redAccent,
            //                   radius: 20,
            //                 ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if ((newContainerHeight >= 0 && details.primaryDelta! >= 0) ||
                    (newContainerHeight <= 200 && details.primaryDelta! <= 0)) {
                  previousContainerHeight = newContainerHeight;
                  setState(() {
                    newContainerHeight -= details.primaryDelta!;
                  });
                  if (newContainerHeight <= previousContainerHeight) {
                    setState(() {
                      fullHeight = false;
                    });
                  } else {
                    setState(() {
                      fullHeight = true;
                    });
                  }
                }
              },
              onVerticalDragEnd: (details) {
                if (fullHeight) {
                  setState(() {
                    newContainerHeight = 200;
                  });
                } else {
                  setState(() {
                    newContainerHeight = 0;
                  });
                }
              },
              child: RoundedContainer(
                color: Colors.white24,
                width: Get.width,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: -20 + Get.width / 3.5 + newContainerHeight,
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MainButton(
                          text: "Зберегти",
                          // isActive: placedUnit != null,
                          isActive: selectedUnit >= 0,
                          onPressed: isCommander
                              ? () => Get.back()
                              : () => controller.saveReportUnit(
                                    units[selectedUnit].id,
                                    units[selectedUnit].name,
                                    unitPhotos,
                                    getPositionOfPlacedUnit(),
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 15,
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedContainer(
                                height: 5,
                                width: 80,
                                color: LIGHT_GRAY,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            physics: fullHeight
                                ? const BouncingScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            itemCount: units.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                decoration: selectedUnit == i
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: LIGHT_GRAY,
                                          width: 3.8,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                      )
                                    : null,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          if (selectedUnit != i) {
                                            changeSelectedUnit(i);
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: selectedUnit == i
                                            ? Get.width / 4.2
                                            : Get.width / 4,
                                        width: Get.width / 4,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                NetworkImage(units[i].imageUrl),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1.0,
                                    ),
                                    Text(
                                      units[i].name,
                                      style: MAIN_TEXT_STYLE_WHITE,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void changeSelectedUnit(int index) async {
    setState(() {
      selectedUnit = index;
    });
    if (placedUnit != null && !isCommander) {
      var oldPosition = placedUnit!.position;
      var oldScale = placedUnit!.scale;
      var oldEulerAngles = placedUnit!.eulerAngles;
      await _downloadAndStoreModel(units[index].modelUrl);
      arkitController.remove("unit");
      placedUnit = ARKitReferenceNode(
        name: "unit",
        url: localModelPath!,
        eulerAngles: oldEulerAngles,
        scale: oldScale,
        position: oldPosition,
      );
      arkitController.add(placedUnit!);
    }
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    if (isCommander) {
      arkitController.onNodeTap = (nodes) => onNodeTap(nodes);
    }
    arkitController.onARTap = (ar) => _onARTap(ar);
  }

  void onNodeTap(List<String> nodes) {
    if (nodes.isNotEmpty) {
      final String nodeName = nodes.first; // Беремо перший вузол у списку
      if (nodeName.contains("unit")) {
        RemoveUnitDialog(
          remove: () {
            arkitController.remove(nodeName);
          },
        );
      }
    }
  }

  bool arLoading = false;

  void _onARTap(List<ARKitTestResult> ar) async {
    final point = ar.firstWhereOrNull(
      (o) => o.type == ARKitHitTestResultType.featurePoint,
    );
    if (point != null) {
      final position = vector.Vector3(
        point.worldTransform.getColumn(3).x,
        point.worldTransform.getColumn(3).y,
        point.worldTransform.getColumn(3).z,
      );

      // Check the number of nodes in the scene
      final String numberOfNodes =
          DateTime.now().millisecondsSinceEpoch.toString();

      if (isCommander) {
        if (placedMap == null) {
          // Place the map on the first tap
          final material = ARKitMaterial(
            diffuse: ARKitMaterialProperty.image(localImagePath),
          );
          final plane = ARKitPlane(
            width: 1,
            height: 1,
            materials: [material],
          );
          final eulerAngles = vector.Vector3(0, -math.pi / 2, 0);
          placedMap = ARKitNode(
            geometry: plane,
            position: position,
            eulerAngles: eulerAngles,
          );
          arkitController.add(placedMap!);
        } else {
          // Place units on subsequent taps
          await _downloadAndStoreModel(units[selectedUnit].modelUrl);
          final unitName =
              "unit$numberOfNodes"; // Name based on the number of nodes
          var newUnit = ARKitReferenceNode(
            name: unitName,
            url: localModelPath!,
            scale: vector.Vector3.all(0.02),
            position: position,
          );
          arkitController.add(newUnit!);
        }
      } else {
        if (placedUnit == null) {
          await _downloadAndStoreModel(units[selectedUnit].modelUrl);
        } else {
          arkitController.remove("unit");
        }
        placedUnit = ARKitReferenceNode(
          name: "unit",
          url: localModelPath!,
          scale: vector.Vector3.all(0.1),
          position: position,
        );
        arkitController.add(placedUnit!);
      }
    }
  }

  Future<void> _downloadAndStoreModel(String url) async {
    setState(() {
      arLoading = true;
    });
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/model.usdz');
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        localModelPath = file.path;
      });
    } else {}

    setState(() {
      arLoading = false;
    });
  }

  LatLng getPositionOfPlacedUnit() {
    if (placedUnit == null) {
      return LatLng(0,
          0); // Повертаємо нульові координати, якщо немає розміщених об'єктів
    }

    // Отримуємо локальні координати розміщеного об'єкта
    final vector.Vector3 localPosition = placedUnit!.position;

    // Поточні географічні координати користувача
    final double currentLatitude =
        mainController.currentLocation.value.latitude;
    final double currentLongitude =
        mainController.currentLocation.value.longitude;

    // Конвертуємо локальні координати назад у географічні координати
    return convertLocalToLatLng(
        localPosition, currentLatitude, currentLongitude);
  }

  LatLng convertLocalToLatLng(vector.Vector3 localPosition,
      double currentLatitude, double currentLongitude) {
    double scale =
        0.01; // Той самий масштаб, що використовувався при розміщенні об'єктів

    // Розрахунок відстані та напрямку від поточного місцезнаходження
    double distance =
        math.sqrt(math.pow(localPosition.x, 2) + math.pow(localPosition.z, 2)) /
            scale;
    double bearing = math.atan2(localPosition.z, localPosition.x);

    // Розрахунок нових географічних координат
    return calculateLatLngFromBearingAndDistance(
        currentLatitude, currentLongitude, bearing, distance);
  }

  LatLng calculateLatLngFromBearingAndDistance(
      double lat, double lon, double bearing, double distance) {
    const double EarthRadius = 6371.0; // Радіус Землі в кілометрах
    double latRadians = lat * (math.pi / 180);
    double lonRadians = lon * (math.pi / 180);

    double newLat = math.asin(
        math.sin(latRadians) * math.cos(distance / EarthRadius) +
            math.cos(latRadians) *
                math.sin(distance / EarthRadius) *
                math.cos(bearing));
    double newLon = lonRadians +
        math.atan2(
            math.sin(bearing) *
                math.sin(distance / EarthRadius) *
                math.cos(latRadians),
            math.cos(distance / EarthRadius) -
                math.sin(latRadians) * math.sin(newLat));

    return LatLng(newLat * (180 / math.pi), newLon * (180 / math.pi));
  }
}
