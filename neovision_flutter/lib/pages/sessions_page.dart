import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/sessions_controller.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_button.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/create_session_page.dart';
import 'package:neovision_flutter/pages/session_page.dart';
import 'package:neovision_flutter/service/models/role.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class SessionsPage extends GetView<SessionsController> {
  static String id = "/sessions";

  const SessionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCommander =
        controller.mainController.client.value.role == Role.commander;
    return PageWrapper(
      withListView: false,
      header: Header(
        middleWidget: Text(
          "Сесії",
          style: MAIN_TEXT_STYLE_WHITE.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        rightWidget: isCommander
            ? RoundedButton(
                onTap: () => Get.toNamed(CreateSessionPage.id),
                svgIcon: "assets/icons/create_icon.svg",
              )
            : null,
      ),
      children: [
        Obx(
          () => Expanded(
            child: controller.sessions.value.isEmpty &&
                    !controller.loadingSessions.value
                ? Center(
                    child: Text(
                      isCommander
                          ? "Створіть сесію"
                          : "Доступні сесії відсутні",
                      style: MAIN_TEXT_STYLE_WHITE.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                : SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    onRefresh: controller.onRefresh,
                    onLoading: controller.onLoading,
                    header: const MaterialClassicHeader(
                      color: Colors.white,
                      backgroundColor: DARK_BROWN,
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: controller.loadingSessions.value
                          ? 5
                          : controller.sessions.value.length,
                      itemBuilder: (_, i) => controller.loadingSessions.value
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.4),
                              highlightColor: BG_COLOR,
                              child: RoundedContainer(
                                  height: 80.0, child: Container()),
                            )
                          : SessionCard(
                              controller: controller,
                              index: i,
                            ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.controller,
    required this.index,
  });

  final SessionsController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      onTap: () => Get.toNamed(
        SessionPage.id,
        arguments: controller.sessions.value[index],
      ),
      height: 80,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RoundedContainer(
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      // Adjust the radius as needed
                      child: Image.network(
                        controller.sessions.value[index].sessionMap,
                        fit: BoxFit.cover,
                      ),
                    )),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.sessions.value[index].name,
                      style: MAIN_TEXT_STYLE_BLACK,
                    ),
                    Text(
                      Jiffy.parse(controller.sessions.value[index].startTime
                              .toString())
                          .format(pattern: "dd.MM.yyyy"),
                      style: MAIN_TEXT_STYLE_BLACK.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/subordinate_icon.svg",
                  height: 20,
                ),
                Text(
                  controller.sessions.value[index].subordinatesIds.length
                      .toString(),
                  style: MAIN_TEXT_STYLE_BLACK,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
