import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/sessionShowArPage.dart';
import 'package:neovision_flutter/service/models/recon.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';
import 'package:neovision_flutter/service/models/role.dart';

class ReconPage extends GetView<MainController> {
  final Recon recon;
  const ReconPage({
    Key? key,
    required this.recon,
  }) : super(key: key);

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
          height: 20,
        ),
        Text(
          "Текст доповіді :",
          style: MAIN_TEXT_STYLE_WHITE.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          recon.report,
          style: MAIN_TEXT_STYLE_WHITE,
        ),
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: controller.client.value.role == Role.commander,
          child: Column(
            children: [
              MainButton(
                  text: "Переглянути",
                  onPressed: () => Get.to(
                      SessionShowArPage(reportUnits: recon.reportUnits))),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Text(
          "Бойові одиниці :",
          style: MAIN_TEXT_STYLE_WHITE.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: recon.reportUnits
              .map((unit) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: FullReportUnitWidget(reportUnit: unit),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class FullReportUnitWidget extends StatelessWidget {
  final ReportUnit reportUnit;
  const FullReportUnitWidget({
    Key? key,
    required this.reportUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: Get.width,
      color: Colors.white24,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                reportUnit.name,
                style: MAIN_TEXT_STYLE_WHITE,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: reportUnit.description.isNotEmpty,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      reportUnit.description,
                      style: MAIN_TEXT_STYLE_WHITE,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                "${reportUnit.latitude}\n${reportUnit.longitude}",
                style: MAIN_TEXT_STYLE_WHITE,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Щоб уникнути прокрутки всередині прокручуваного батьківського віджету
              shrinkWrap: true, // Щоб GridView зайняв лише необхідний простір
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Два фото в рядку
                crossAxisSpacing: 10, // Відступи між фото по осі X
                mainAxisSpacing: 10, // Відступи між фото по осі Y
                childAspectRatio:
                    1, // Співвідношення сторін для кожної картинки
              ),
              itemCount: reportUnit.unitPhotoUrls.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    reportUnit.unitPhotoUrls[index],
                    fit: BoxFit.cover, // Заповнення простору картинкою
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
