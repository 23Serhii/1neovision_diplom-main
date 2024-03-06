import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';

class NotFoundPage extends StatelessWidget {
  static String id = "/not_found";
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      header: Header(),
      children: [
        SizedBox(
          height: Get.height / 5,
        ),
        Column(
          children: [
            const Text(
              "Oh No!",
              style: MAIN_TEXT_STYLE_WHITE,
            ),
            Text(
              "PAGE NOT FOUND!".tr,
              style: MAIN_TEXT_STYLE_WHITE.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "But it just a 404 Error!".tr,
              style: MAIN_TEXT_STYLE_WHITE,
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/404_image.png",
              width: Get.width / 1.2,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              " What you are looking for\nmay have been misplaced.".tr,
              style: MAIN_TEXT_STYLE_WHITE,
            ),
          ],
        ),
      ],
    );
  }
}
