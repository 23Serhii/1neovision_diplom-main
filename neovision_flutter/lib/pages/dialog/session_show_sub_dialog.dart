import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/session_controller.dart';
import 'package:neovision_flutter/controllers/subordinate_controller.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/service/models/client.dart';

class SessionShowSubDialog extends GetView<SessionController> {
  final SubordinateController subordinateController = Get.find();

  SessionShowSubDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0),
          child: Material(
            color: Colors.transparent,
            child: RoundedContainer(
              width: Get.width / 1.2,
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Виконавці",
                      style: MAIN_TEXT_STYLE_BLACK.copyWith(fontSize: 28),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: RoundedContainer(
                          color: Colors.black12,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...List.generate(
                                          controller.session.value
                                              .subordinatesIds.length, (index) {
                                        return UserItem(
                                          subordinate: subordinateController
                                              .subordinates.value
                                              .firstWhere(
                                            (Client sub) =>
                                                sub.id ==
                                                controller.session.value
                                                    .subordinatesIds[index],
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MainButton(
                      width: 120,
                      text: "Закрити",
                      onPressed: Get.back,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserItem extends StatefulWidget {
  const UserItem({
    Key? key,
    required this.subordinate,
  }) : super(key: key);
  final Client subordinate;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: 70,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Get.width,
              height: 0,
              color: BG_COLOR,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: BG_COLOR,
                  backgroundImage: NetworkImage(widget.subordinate.avatar),
                  radius: 23,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subordinate.login,
                      style: MAIN_TEXT_STYLE_BLACK,
                    ),
                    Text(
                      widget.subordinate.email,
                      style: MAIN_TEXT_STYLE_BLACK.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: Get.width,
              height: 2,
              color: BG_COLOR,
            ),
          ],
        ),
      ),
    );
  }
}
