import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/service/pages.dart';

void main() async {
  await initializeDependencies();
  final kINITIALROUTE = await getInitialRoute();
  runApp(OriApp(kINITIALROUTE));
}

Future<void> initializeDependencies() async {
  await GetStorage.init();
  Get.put(MainController());
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      1024 * 1024 * 800; // 800 MB
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor:
          Colors.transparent, // If you want a transparent status bar background
      statusBarIconBrightness:
          Brightness.light, // Set the status bar text color to dark (black)
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class OriApp extends StatelessWidget {
  final String kINITIALROUTE;
  const OriApp(this.kINITIALROUTE, {super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: kINITIALROUTE,
      unknownRoute: kUKNOWNROUTE,
      getPages: kPAGES,
    );
  }
}
