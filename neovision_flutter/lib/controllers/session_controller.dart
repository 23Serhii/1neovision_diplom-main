import 'package:get/get.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/service/models/session.dart';

class SessionController extends GetxController {
  final MainController mainController = Get.find();
  late Rx<Session> session;

  @override
  void onInit() {
    session = (Get.arguments as Session).obs;
    super.onInit();
  }

  deleteSession() async {
    Get.back();
    await mainController.neoApi.deleteSession(session.value.id);
    mainController.updateSessions();
  }
}
