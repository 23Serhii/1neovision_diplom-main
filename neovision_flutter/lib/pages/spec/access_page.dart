import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';

class AccessPage extends StatelessWidget {
  static String id = "/access";

  const AccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments == null) return Container();
    return PageWrapper(
      children: [
        SizedBox(
          height: Get.height / 3.5,
        ),
        Column(
          children: [
            Text(
              "ALLOW ${Get.arguments} ACCESS",
              style: MAIN_TEXT_STYLE_WHITE.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "In order to display the contents\nORIENTEERING.PRO needs\naccess to this device’s${"${Get.arguments.toString().toLowerCase()}.".tr}",
              style: MAIN_TEXT_STYLE_WHITE,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "In App info, please grant permissions or tap the button",
              textAlign: TextAlign.center,
              style: MAIN_TEXT_STYLE_WHITE,
            ),
            const SizedBox(
              height: 20,
            ),
            MainButton(
              text: "ALLOW".tr,
              width: 200,
              onPressed: () {},
              isActive: true,
            ),
          ],
        ),
      ],
    );
  }
}
