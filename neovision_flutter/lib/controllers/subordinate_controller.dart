import 'package:get/get.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/service/models/client.dart';
import 'package:neovision_flutter/service/models/role.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SubordinateController extends GetxController {
  MainController mainController = Get.find();
  Rx<List<Client>> subordinates = Rx<List<Client>>([]);
  Rx<bool> loading = true.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    if (mainController.client.value.role == Role.commander) initSubordinates();
  }

  onRefresh() {
    initSubordinates();
    refreshController.refreshCompleted();
  }

  onLoading() {
    initSubordinates();
    refreshController.loadComplete();
  }

  initSubordinates() async {
    loading.value = true;
    subordinates.value.clear();
    for (var client
        in (await mainController.neoApi.getSubordinates() as List)) {
      subordinates.value.add(Client.fromJson(client));
    }
    loading.value = false;
  }
}
