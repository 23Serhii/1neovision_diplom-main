import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/recon_controller.dart';
import 'package:neovision_flutter/global_widgets/custom_input.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';

class ReconUnitDialog extends GetView<ReconController> {
  final ReportUnit reportUnit;
  ReconUnitDialog({Key? key, required this.reportUnit}) : super(key: key);
  final TextEditingController descriptionEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    descriptionEditingController.text = reportUnit.description;
    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: RoundedContainer(
            height: Get.height / 2,
            width: Get.width / 1.2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    primary: true, // Enable PrimaryScrollController
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Опис одиниці",
                          style: MAIN_TEXT_STYLE_WHITE,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        CustomInput(
                          hintText: "Опис",
                          controller: descriptionEditingController,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: MainButton(
                                color: BG_COLOR,
                                text: "Відмінити",
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: MainButton(
                                text: "Зберегти",
                                onPressed: () =>
                                    controller.saveReportUnitDescription(
                                  reportUnit,
                                  descriptionEditingController.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        GridView.builder(
                          physics:
                              const NeverScrollableScrollPhysics(), // Щоб уникнути прокрутки всередині прокручуваного батьківського віджету
                          shrinkWrap:
                              true, // Щоб GridView зайняв лише необхідний простір
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Два фото в рядку
                            crossAxisSpacing: 10, // Відступи між фото по осі X
                            mainAxisSpacing: 10, // Відступи між фото по осі Y
                            childAspectRatio:
                                1, // Співвідношення сторін для кожної картинки
                          ),
                          itemCount: reportUnit.photosToLoad.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.memory(
                                reportUnit.photosToLoad[index],
                                fit: BoxFit
                                    .cover, // Заповнення простору картинкою
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
