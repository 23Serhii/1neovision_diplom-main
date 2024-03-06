import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/recon_controller.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:neovision_flutter/pages/dialog/recon_unit_dialog.dart';
import 'package:neovision_flutter/service/models/report_unit.dart';

class ReportUnitWidget extends GetView<ReconController> {
  final ReportUnit reportUnit;

  const ReportUnitWidget({Key? key, required this.reportUnit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: BG_COLOR,
              autoClose: true,
              flex: 2,
              onPressed: (context) => controller.deleteReportUnit(reportUnit),
              icon: Icons.delete_outline,
              foregroundColor: Colors.red,
              label: 'Delete',
            ),
          ],
        ),
        child: RoundedContainer(
          onTap: () => Get.dialog(ReconUnitDialog(reportUnit: reportUnit)),
          height: 60,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(reportUnit.name, style: MAIN_TEXT_STYLE_BLACK)),
                // Text(reconUnit.description, style: MAIN_TEXT_STYLE_BLACK),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Latitude: ${reportUnit.latitude}",
                        style: MAIN_TEXT_STYLE_BLACK),
                    Text("Longitude: ${reportUnit.longitude}",
                        style: MAIN_TEXT_STYLE_BLACK),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/camera_icon.svg",
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      reportUnit.photosToLoad.length.toString(),
                      style: MAIN_TEXT_STYLE_BLACK,
                    )
                  ],
                ),

                // SizedBox(height: 10),
                // ...reconUnit.photos.map((photo) => Image.network(photo.imageUrl)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
