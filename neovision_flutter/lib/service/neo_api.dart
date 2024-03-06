import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:neovision_flutter/constants/functions.dart';
import 'package:neovision_flutter/pages/auth_page.dart';
import 'package:neovision_flutter/pages/spec/not_found_page.dart';
import 'package:neovision_flutter/pages/spec/oops_page.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';

enum Operation {
  post,
  put,
  get,
  delete,
}

class NeoApi extends GetxController {
  final dio.Dio _dio = dio.Dio();

  final String _baseUrl = 'http://192.168.206.110:8080';

  NeoApi() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  void setApiKey(String apiKey) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
  }

  Future<dynamic> _sendRequest(String path, var body,
      {Operation type = Operation.get, bool dialogError = false}) async {
    print("REQUEST: $path");
    try {
      dio.Options options =
          dio.Options(method: type.toString().split('.').last);

      // Якщо тіло запиту є FormData, то змінюємо Content-Type
      if (body is dio.FormData) {
        options.contentType = 'multipart/form-data';
      }

      final response = await _dio.request(
        path,
        data: body,
        options: options,
      );

      print("RESULT: ${response.data}");
      return response.data;
    } on dio.DioException catch (e) {
      String message = 'An unexpected error occurred.';
      int code = 0;

      if (e.response != null) {
        code = e.response?.statusCode ?? 0;
        if (e.response?.data is Map && e.response!.data["error"] != null) {
          message = e.response!.data["error"];
        } else if (e.response?.data is String) {
          message = e.response!.data;
        }
      } else {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          Get.offAllNamed(OopsPage.id, arguments: [true, "", 0]);
        }
        message = "Unable to connect to the server.";
      }
      if (dialogError) {
        Get.snackbar("Error", message);
      } else {
        _showErrorScreen(code, message);
      }
      return null;
    }
  }

  void _showErrorScreen(int code, String message) {
    print(code);
    print(message);
    if (code == 404) {
      Get.toNamed(NotFoundPage.id);
    } else if (code == 403 || code == 401) {
      setApiKey("");
      Get.offAllNamed(AuthPage.id);
    } else {
      Get.toNamed(OopsPage.id, arguments: [false, message, code]);
    }
  }

  // Запити

  login(String email, String password) async {
    return await _sendRequest(
      "/auth/app/login",
      {
        "email": email,
        "password": password,
      },
      dialogError: true,
      type: Operation.post,
    );
  }

  getInfo() async {
    return await _sendRequest("/app/client/info", null);
  }

  createSession(String name, String description, List<int> subIds,
      LatLng squareCenter, Uint8List? mapBytes) async {
    dio.MultipartFile? mapFile;
    if (mapBytes != null) {
      mapFile = dio.MultipartFile.fromBytes(
        mapBytes.toList(),
        filename: generateMapFileName(),
        contentType: MediaType(
          'image',
          'jpg',
        ),
      );
    }

    var formData = dio.FormData.fromMap({
      "name": name,
      "description": description,
      "centerLat": squareCenter.latitude,
      "centerLng": squareCenter.longitude,
      "subordinatesIds": subIds,
      "mapFile": mapFile,
    });

    return await _sendRequest(
      "/app/session/create",
      formData,
      type: Operation.post,
    );
  }

  getSessions() async {
    return await _sendRequest("/app/session/list", null);
  }

  getSubordinates() async {
    return await _sendRequest("/app/client/subordinates", null);
  }

  deleteSession(int id) async {
    return await _sendRequest(
      "/app/session/delete",
      dio.FormData.fromMap({"id": id}),
      type: Operation.delete,
    );
  }

  getUnits() async {
    return await _sendRequest("/app/units/list", null);
  }

  Future createRecon(
    String report,
    int createdById,
    int sessionId,
    List<ReportUnit> reportUnits,
  ) async {
    dio.FormData formData = dio.FormData();

    // Додаємо прості поля
    formData.fields
      ..add(MapEntry("report", report))
      ..add(MapEntry("createdById", createdById.toString()))
      ..add(MapEntry("sessionId", sessionId.toString()));

    // Додаємо ReportUnits
    for (int i = 0; i < reportUnits.length; i++) {
      ReportUnit unit = reportUnits[i];

      // Додаємо інформацію про ReportUnit
      formData.fields
        ..add(MapEntry("reportUnits[$i].unitId", unit.unitId.toString()))
        ..add(MapEntry("reportUnits[$i].description", unit.description))
        ..add(MapEntry("reportUnits[$i].latitude", unit.latitude.toString()))
        ..add(MapEntry("reportUnits[$i].longitude", unit.longitude.toString()));

      // Додаємо фотографії для ReportUnit, якщо вони є
      if (unit.photosToLoad.isNotEmpty) {
        for (int j = 0; j < unit.photosToLoad.length; j++) {
          formData.files.add(
            MapEntry(
              "reportUnits[$i].unitPhotoFiles[$j]",
              dio.MultipartFile.fromBytes(unit.photosToLoad[j],
                  filename: generateMapFileName()),
            ),
          );
        }
      }
    }

    // Відправте запит
    return await _sendRequest("/app/recon/create", formData,
        type: Operation.post);
  }
}
