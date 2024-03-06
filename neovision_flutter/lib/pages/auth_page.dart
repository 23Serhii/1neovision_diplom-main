import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/auth_controller.dart';
import 'package:neovision_flutter/global_widgets/custom_input.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/spec/loading_page.dart';

class AuthPage extends GetView<AuthController> {
  static String id = "/auth";

  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PageWrapper(
        withBackground: true,
        withListView: false,
        children: [
          controller.loading.value
              ? const LoadingPage()
              : Column(
                  children: [
                    SizedBox(
                      height: Get.height / 5,
                    ),
                    RoundedContainer(
                      height: Get.height / 3,
                      color: BG_COLOR.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "NeoVision",
                              style: BIG_TEXT_STYLE,
                            ),
                            CustomInput(
                              width: Get.width,
                              hintText: "Пошта",
                              controller:
                                  controller.emailEditingController.value,
                            ),
                            CustomInput(
                              width: Get.width,
                              hintText: "Пароль",
                              isPassword: true,
                              controller:
                                  controller.passwordEditingController.value,
                            ),
                            MainButton(
                              text: "Авторизуватись",
                              width: 200,
                              onPressed: () async => controller.signIn(),
                              // onPressed: () => Get.toNamed(SessionArPage.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
