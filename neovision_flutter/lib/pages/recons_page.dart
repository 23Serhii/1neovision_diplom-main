import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/session_controller.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/recon_page.dart';
import 'package:neovision_flutter/service/models/recon.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';

class ReconsPage extends GetView<SessionController> {
  static String id = "/recons_page";
  const ReconsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      header: Header(
        middleWidget: const Text(
          "Доповіді",
          style: MAIN_TEXT_STYLE_WHITE,
        ),
      ),
      children: [
        const SizedBox(
          height: 20,
        ),
        Column(
          children: controller.session.value.recons
              .map(
                (recon) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ReconCard(
                    recon: recon,
                    userAvatar: controller.mainController.client.value.avatar,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class ReconCard extends StatelessWidget {
  const ReconCard({
    super.key,
    required this.recon,
    required this.userAvatar,
  });

  final Recon recon;
  final String userAvatar;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      onTap: () => Get.to(
        () => ReconPage(
          recon: recon,
        ),
      ),
      height: 80,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Image.network(
                userAvatar,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/ar_icon.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  recon.reportUnits.length.toString(),
                  style: MAIN_TEXT_STYLE_BLACK,
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/camera_icon.svg",
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  recon.reportUnits
                      .fold(
                          0,
                          (int previousValue, ReportUnit reportUnit) =>
                              previousValue + reportUnit.unitPhotoUrls.length)
                      .toString(),
                  style: MAIN_TEXT_STYLE_BLACK,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  recon.creatorName,
                  style: MAIN_TEXT_STYLE_BLACK,
                ),
                Text(
                  Jiffy.parse(recon.timestamp.toString())
                      .format(pattern: "dd.MM.yyyy, HH:MM"),
                  style: MAIN_TEXT_STYLE_BLACK.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
