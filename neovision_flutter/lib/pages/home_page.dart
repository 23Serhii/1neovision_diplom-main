import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/main_controller.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/create_recon_page.dart';
import 'package:neovision_flutter/pages/main_map_page.dart';
import 'package:neovision_flutter/pages/sessions_page.dart';
import 'package:neovision_flutter/pages/subordinate_page.dart';
import 'package:neovision_flutter/service/models/role.dart';

class HomePage extends GetView<MainController> {
  static String id = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      header: Header(
        withoutBack: true,
        middleWidget: const Text(
          "NeoVision",
          style: BIG_TEXT_STYLE,
        ),
        rightWidget: RoundedButton(
          onTap: controller.logout,
          svgIcon: 'assets/icons/logout_icon.svg',
        ),
      ),
      children: [
        Column(
          children: [
            SizedBox(
              height: Get.height / 7,
            ),
            CircleAvatar(
              radius: 55.0,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(controller.client.value.avatar),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              controller.client.value.login,
              style: MAIN_TEXT_STYLE_WHITE.copyWith(fontSize: 22),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedContainer(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Visibility(
                      visible: controller.client.value.role == Role.subordinate,
                      child: MenuItem(
                        text: "Створити звіт",
                        onTap: () => Get.toNamed(CreateReconPage.id),
                        icon: "assets/icons/create_icon.svg",
                      ),
                    ),
                    MenuItem(
                      text: "Сесії",
                      onTap: () => Get.toNamed(SessionsPage.id),
                      icon: "assets/icons/sessions_icon.svg",
                    ),
                    Visibility(
                      visible: controller.client.value.role == Role.commander,
                      child: MenuItem(
                        text: "Підлеглі",
                        onTap: () => Get.toNamed(SubordinatePage.id),
                        icon: "assets/icons/subordinate_icon.svg",
                      ),
                    ),
                    Visibility(
                      visible: controller.client.value.role == Role.commander,
                      child: MenuItem(
                        text: "Загальне зведення",
                        onTap: () => Get.toNamed(MainMapPage.id),
                        icon: "assets/icons/map_icon.svg",
                      ),
                    ),
                    MenuItem(
                      text: "Підтримка",
                      isLast: true,
                      onTap: () {},
                      icon: "assets/icons/support_icon.svg",
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
        // MainButton(
        //   text: "logout",
        //   onPressed: () => controller.logout(),
        // )
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final bool isLast;
  final String text;
  final String icon;
  final Function() onTap;

  const MenuItem({
    super.key,
    this.isLast = false,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: MAIN_TEXT_STYLE_BLACK.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SvgPicture.asset(
                    icon,
                    height: 30,
                  ),
                ],
              ),
            ),
            isLast
                ? Container()
                : Container(
                    color: BG_COLOR.withOpacity(0.5),
                    height: 1,
                  )
          ],
        ),
      ),
    );
  }
}
