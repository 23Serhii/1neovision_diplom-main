import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/math.dart';
import 'package:neovision_flutter/controllers/sessions_controller.dart';

class MainMapPage extends StatefulWidget {
  static String id = "/main_map";
  const MainMapPage({Key? key}) : super(key: key);

  @override
  State<MainMapPage> createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  SessionsController sessionsController = Get.find();
  var mapContext;
  var controller;
  double angle = 0.0;
  List<Polygon> squarePolygons = [];
  bool settingLocation = false;
  late Timer timer;
  bool isSatellite = true;
  Marker marker = Marker(markerId: MarkerId("marker"));

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(mapContext)
        .load("assets/images/location_image2.png");
    return byteData.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    FlutterCompass.events!.listen((event) {
      var tempAngle = event.heading;
      if (tempAngle != null) angle = tempAngle;
    });
    getSquares();
  }

  getSquares() {
    squarePolygons.clear();
    sessionsController.sessions.value.forEach((session) {
      setState(() {
        squarePolygons.add(Polygon(
          polygonId: PolygonId("square${session.id}"),
          points: getSquarePoints(
              LatLng(
                session.centerLat,
                session.centerLng,
              ),
              500),
          fillColor: isSatellite
              ? Colors.white.withOpacity(0.3)
              : Colors.black.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: isSatellite ? Colors.white : Colors.black,
        ));
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  onMapCreated(GoogleMapController controller, context) async {
    setState(() {
      mapContext = context;
      this.controller = controller;
    });

    // _onMapTapped(routesController.routesRadiusPosition, tap: true);
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) async {
      try {
        await updateLocation();
      } catch (e) {
        print("timer");
        print(e);
        t.cancel();
      }
    });
  }

  updateLocation() async {
    if (sessionsController.mainController.currentLocation.value != null) {
      try {
        Uint8List imageData = await getMarker();
        updateMarkerAndCircle(
            sessionsController.mainController.currentLocation.value, imageData);
      } catch (e) {
        print("updateLoc");
        print(e);
      }
    }
  }

  animateToLocation() async {
    setState(() {
      settingLocation = true;
    });
    try {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              sessionsController.mainController.currentLocation.value.latitude,
              sessionsController.mainController.currentLocation.value.longitude,
            ),
            zoom: calculateZoom(5, 1000),
          ),
        ),
      );
    } catch (e) {
      print("animateLocation");
      print(e);
      sleep(const Duration(seconds: 1));
      animateToLocation();
    }
    setState(() {
      settingLocation = false;
    });
  }

  void updateMarkerAndCircle(Position newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    setState(() {
      marker = Marker(
          markerId: MarkerId("marker"),
          consumeTapEvents: false,
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          rotation: angle,
          icon: BitmapDescriptor.fromBytes(imageData, size: Size(64, 64)));
    });
  }

  List<LatLng> getSquarePoints(LatLng center, double radius) {
    // Цей метод розраховує куточки квадрата на основі центру і радіуса.
    // Радіус тут виступає як половина довжини сторони квадрата.
    // Ви маєте перевести радіус із метрів у географічні координати, якщо потрібно.

    double latOffset = radius / 111111; // приблизно в метрах на градус
    double lngOffset = radius /
        (111111 * cos(pi * center.latitude / 180)); // коригування для довготи

    return [
      LatLng(center.latitude + latOffset, center.longitude - lngOffset),
      LatLng(center.latitude + latOffset, center.longitude + lngOffset),
      LatLng(center.latitude - latOffset, center.longitude + lngOffset),
      LatLng(center.latitude - latOffset, center.longitude - lngOffset),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            mapType: isSatellite ? MapType.satellite : MapType.normal,
            initialCameraPosition: CameraPosition(
              zoom: calculateZoom(5, 1000),
              target: sessionsController.mainController.currentLocation.value !=
                      null
                  ? LatLng(
                      sessionsController
                          .mainController.currentLocation.value.latitude,
                      sessionsController
                          .mainController.currentLocation.value.longitude)
                  : LatLng(37.42796133580664, -122.085749655962),
            ),
            // ignore: unnecessary_null_comparison
            markers:
                // ignore: unnecessary_null_comparison
                Set.of((marker != null) ? [marker] : []),
            // ignore: unnecessary_null_comparison
            polygons: Set.of(squarePolygons),
            onMapCreated: (GoogleMapController controller) async {
              await onMapCreated(controller, context);
              // Get.appUpdate();
            },
          ),
          Positioned(
            top: 20,
            right: 20,
            child: SafeArea(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSatellite = !isSatellite;
                  });
                  getSquares();
                },
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor:
                      isSatellite ? WHITE_TRANSPARENT : Colors.black54,
                  child: Icon(
                    Icons.layers_outlined,
                    color: isSatellite ? DARK_BROWN : Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                animateToLocation();
              },
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: settingLocation
                    ? isSatellite
                        ? Colors.white
                        : Colors.black
                    : isSatellite
                        ? WHITE_TRANSPARENT
                        : Colors.black54,
                child: SvgPicture.asset(
                  "assets/icons/my_position_icon.svg",
                  colorFilter: ColorFilter.mode(
                    isSatellite ? Colors.black : Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            top: 20.0,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: settingLocation
                        ? isSatellite
                            ? Colors.white
                            : Colors.black
                        : isSatellite
                            ? WHITE_TRANSPARENT
                            : Colors.black54,
                    child: SvgPicture.asset(
                      "assets/icons/arrow_back_icon.svg",
                      color: isSatellite ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
