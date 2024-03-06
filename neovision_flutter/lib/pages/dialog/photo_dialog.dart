import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';

class PhotoDialog extends StatelessWidget {
  final Uint8List photo;
  final Function() onAccept;
  final String text;
  const PhotoDialog({
    Key? key,
    required this.photo,
    required this.onAccept,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        Text(
                          text,
                          style: MAIN_TEXT_STYLE_WHITE,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              photo,
                              height: Get.height / 2,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            MainButton(
                              color: BG_COLOR,
                              width: 120.0,
                              text: "Відмінити".tr,
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MainButton(
                              width: 120.0,
                              text: "Погодити".tr,
                              onPressed: onAccept,
                            ),
                          ],
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
