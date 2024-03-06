import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/sessions_controller.dart';
import 'package:neovision_flutter/controllers/subordinate_controller.dart';
import 'package:neovision_flutter/global_widgets/custom_checkbox.dart';
import 'package:neovision_flutter/global_widgets/main_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/service/models/client.dart';

class SessionSetSubDialog extends GetView<SessionsController> {
  final SubordinateController subordinateController = Get.find();

  SessionSetSubDialog({super.key});

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
                      "Обрати підлеглих",
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
                                          subordinateController.subordinates
                                              .value.length, (index) {
                                        return UserItem(
                                          subordinate: subordinateController
                                              .subordinates.value[index],
                                          sessionsController: controller,
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
    required this.sessionsController,
  }) : super(key: key);
  final Client subordinate;
  final SessionsController sessionsController;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      onTap: () {
        setState(() {});
        if (!widget.sessionsController.newSubordinatesIds.value
            .contains(widget.subordinate.id)) {
          widget.sessionsController.newSubordinatesIds.value
              .add(widget.subordinate.id);
        } else {
          widget.sessionsController.newSubordinatesIds.value
              .removeWhere((value) => value == widget.subordinate.id);
        }
        widget.sessionsController.countSubordinates.value =
            widget.sessionsController.newSubordinatesIds.value.length;
      },
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                CustomCheckBox(
                  isChecked: widget.sessionsController.newSubordinatesIds.value
                      .contains(widget.subordinate.id),
                  onChanged: () {},
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
