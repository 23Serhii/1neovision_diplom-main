import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/pages/auth_page.dart';

class OopsPage extends StatefulWidget {
  static String id = "/oops";
  const OopsPage({Key? key}) : super(key: key);

  @override
  State<OopsPage> createState() => _OopsPageState();
}

class _OopsPageState extends State<OopsPage> {
  bool isInternetError = false;
  MainController mainController = Get.find();

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      setState(() {
        isInternetError = Get.arguments[0];
      });
    }
    if (isInternetError) {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          timer.cancel();
          if (await mainController.storage.read(key: "token") != null) {
            if (mainController.initProfileLoading.value) {
              mainController.initProfile();
            } else {
              Get.offAllNamed(AuthPage.id);
            }
          } else {
            Get.offAllNamed(AuthPage.id);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      children: [
        SizedBox(
          height: Get.height / 3.5,
        ),
        Column(
          children: [
            Text(
              "Oooops...,".tr,
              style: MAIN_TEXT_STYLE_WHITE,
            ),
            Text(
              "something went wrong...".tr,
              style: MAIN_TEXT_STYLE_WHITE,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/oops_image.png",
              width: Get.width / 1.2,
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: !isInternetError && Get.arguments[2] != 0,
              child: Text(
                Get.arguments[2].toString(),
                style: MAIN_TEXT_STYLE_WHITE,
              ),
            ),
            Text(
              isInternetError
                  ? "Please check your network connection".tr
                  : Get.arguments[1],
              style: MAIN_TEXT_STYLE_WHITE,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
