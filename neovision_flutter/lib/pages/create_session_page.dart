import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/sessions_controller.dart';
import 'package:neovision_flutter/global_widgets/custom_input.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/dialog/session_set_sub_dialog.dart';
import 'package:neovision_flutter/pages/map_page.dart';
import 'package:neovision_flutter/pages/spec/loading_page.dart';

class CreateSessionPage extends GetView<SessionsController> {
  static String id = "/create_session";

  const CreateSessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PageWrapper(
        header: Header(
          middleWidget: Text(
            "Створення сесії",
            style: MAIN_TEXT_STYLE_WHITE.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          rightWidget: RoundedButton(
            onTap: controller.clear,
            imageIcon: "assets/images/clear_image.png",
          ),
        ),
        children: [
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "Назва сесії",
            style: MAIN_TEXT_STYLE_WHITE,
          ),
          const SizedBox(
            height: 10.0,
          ),
          CustomInput(
            hintText: "Назва",
            controller: controller.newNameEditingController,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "Опис сесії",
            style: MAIN_TEXT_STYLE_WHITE,
          ),
          const SizedBox(
            height: 10.0,
          ),
          CustomInput(
            hintText: "Опис",
            height: 150,
            controller: controller.newDescriptionEditingController,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Obx(
            () => Text(
              "Виконавці (обрано ${controller.countSubordinates.value})",
              style: MAIN_TEXT_STYLE_WHITE,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          MainButton(
            text: "Обрати",
            onPressed: () => Get.dialog(SessionSetSubDialog()),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "Квадрат опрацювання",
            style: MAIN_TEXT_STYLE_WHITE,
          ),
          const SizedBox(
            height: 10.0,
          ),
          RoundedContainer(
            onTap: () => Get.toNamed(MapPage.id),
            color: Colors.white,
            height: 100,
            child: controller.mapLoading.value
                ? const LoadingPage()
                : controller.showMap.value
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        // Adjust the radius as needed
                        child: Image.network(
                          controller.mapUrl.value,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: SvgPicture.asset("assets/icons/map_icon.svg")),
          ),
          const SizedBox(
            height: 20.0,
          ),
          MainButton(
            text: "Зберегти",
            onPressed: controller.createSession,
            isActive: !controller.mapLoading.value,
          )
        ],
      ),
    );
  }
}
