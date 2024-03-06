import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/recon_controller.dart';
import 'package:neovision_flutter/global_widgets/custom_input.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/report_unit_widget.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/global_widgets/session_property.dart';
import 'package:neovision_flutter/pages/sessionArPage.dart';
import 'package:neovision_flutter/pages/spec/loading_page.dart';
import 'package:neovision_flutter/service/models/session.dart';

class CreateReconPage extends GetView<ReconController> {
  static String id = "/recon";

  const CreateReconPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      header: Header(
        middleWidget: const Text(
          "Рекогностування",
          style: MAIN_TEXT_STYLE_WHITE,
        ),
      ),
      children: [
        const SizedBox(
          height: 20.0,
        ),
        const Text(
          "Сесія",
          style: MAIN_TEXT_STYLE_WHITE,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Get.arguments != null
            ? CustomInput(
                enabled: false,
                initialValue: controller.session.value.name,
              )
            : Obx(
                () => controller.loading.value
                    ? const LoadingPage()
                    : RoundedContainer(
                        color: Colors.white,
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Center(
                            child: DropdownButton<String>(
                              value: controller.session.value.name,
                              isExpanded: true,
                              icon: SvgPicture.asset(
                                  "assets/icons/arrow_down_icon.svg"),
                              style: MAIN_TEXT_STYLE_BLACK,
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                controller.session.value = controller
                                    .sessionsController.sessions.value
                                    .firstWhere((Session session) =>
                                        session.name == newValue);
                              },
                              items: controller
                                  .sessionsController.sessions.value
                                  .map<DropdownMenuItem<String>>(
                                      (Session value) {
                                return DropdownMenuItem<String>(
                                  value: value.name,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
              ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Доповідь та опис по результатам",
          style: MAIN_TEXT_STYLE_WHITE,
        ),
        const SizedBox(
          height: 10.0,
        ),
        CustomInput(
          hintText: "Текст доповіді",
          height: 150,
          controller: controller.reportEditingController,
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(
          () => Column(
            children: controller.reportUnits.value
                .map((unit) => ReportUnitWidget(reportUnit: unit))
                .toList(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SessionProperty(
          iconData: "assets/icons/ar_icon.svg",
          text: "Додати бойову одиницю",
          onTap: () => Get.toNamed(SessionArPage.id),
        ),
        const SizedBox(
          height: 10,
        ),
        MainButton(
          text: "Відправити на розгляд",
          onPressed: controller.saveRecon,
        ),
      ],
    );
  }
}
