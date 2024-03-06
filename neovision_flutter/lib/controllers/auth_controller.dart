import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/pages/spec/loading_page.dart';

class AuthController extends GetxController {
  Rx<bool> loading = false.obs;
  MainController mainController = Get.find();
  Rx<TextEditingController> emailEditingController =
      TextEditingController(text: "neovision@gmail.com").obs;
  Rx<TextEditingController> passwordEditingController =
      TextEditingController(text: "zsxadc1234").obs;

  signIn() async {
    loading.toggle();
    var result = await mainController.neoApi.login(
      emailEditingController.value.text,
      passwordEditingController.value.text,
    );
    if (result != null) {
      await mainController.storage.write(key: "token", value: result['token']);
      Get.offAllNamed(LoadingPage.id);
      mainController.initProfile();
    }
    loading.toggle();
  }
}
