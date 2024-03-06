import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/session_controller.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_button.dart';
import 'package:neovision_flutter/global_widgets/session_property.dart';
import 'package:neovision_flutter/pages/create_recon_page.dart';
import 'package:neovision_flutter/pages/dialog/session_show_sub_dialog.dart';
import 'package:neovision_flutter/pages/recons_page.dart';
import 'package:neovision_flutter/pages/sessionArPage.dart';
import 'package:neovision_flutter/service/models/role.dart';

class SessionPage extends GetView<SessionController> {
  static String id = "/session";

  const SessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCommander =
        controller.mainController.client.value.role == Role.commander;

    return PageWrapper(
      header: Header(
        middleWidget: Text(
          controller.session.value.name,
          style: MAIN_TEXT_STYLE_WHITE.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        rightWidget: isCommander
            ? RoundedButton(
                svgIcon: "assets/icons/trash_icon.svg",
                onTap: controller.deleteSession,
                color: Colors.redAccent,
              )
            : null,
      ),
      children: [
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: isCommander,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: SessionProperty(
                  iconData: "assets/icons/subordinate_icon.svg",
                  count: controller.session.value.subordinatesIds.length,
                  text: "виконавці",
                  onTap: () {
                    Get.dialog(SessionShowSubDialog());
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SessionProperty(
                  iconData: "assets/icons/create_icon.svg",
                  text: "доповіді",
                  count: controller.session.value.recons.length,
                  onTap: () => Get.toNamed(ReconsPage.id),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              controller.session.value.sessionMap,
              fit: BoxFit.cover,
              height: 240.0,
              width: Get.width,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Опис :",
          style: MAIN_TEXT_STYLE_WHITE.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          controller.session.value.description,
          style: MAIN_TEXT_STYLE_WHITE,
        ),
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: !isCommander,
          child: Column(
            children: [
              Obx(
                () => SessionProperty(
                  iconData: "assets/icons/sessions_icon.svg",
                  text: "Мої доповіді",
                  count: controller.session.value.recons.length,
                  onTap: () => Get.toNamed(ReconsPage.id),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        isCommander
            ? MainButton(
                text: "ОПРАЦЮВАТИ",
                onPressed: () => Get.toNamed(SessionArPage.id),
              )
            : MainButton(
                text: "Здійснити рекогностування",
                onPressed: () => Get.toNamed(
                  CreateReconPage.id,
                  arguments: controller.session.value,
                ),
              ),
      ],
    );
  }
}
