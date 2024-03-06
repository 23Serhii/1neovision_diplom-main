import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/controllers/subordinate_controller.dart';
import 'package:neovision_flutter/global_widgets/header.dart';
import 'package:neovision_flutter/global_widgets/page_wrapper.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class SubordinatePage extends GetView<SubordinateController> {
  static String id = "/subordinate";

  const SubordinatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      withListView: false,
      header: Header(
        middleWidget: Text(
          "Підлеглі",
          style: MAIN_TEXT_STYLE_WHITE.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      children: [
        Obx(
          () => Expanded(
            child: controller.subordinates.value.isEmpty &&
                    !controller.loading.value
                ? Center(
                    child: Text(
                      "Підлеглі відсутні.".tr,
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
                      itemCount: controller.loading.value
                          ? 5
                          : controller.subordinates.value.length,
                      itemBuilder: (_, i) => controller.loading.value
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.4),
                              highlightColor: BG_COLOR,
                              child: RoundedContainer(
                                  height: 80.0, child: Container()),
                            )
                          : RoundedContainer(
                              height: 80,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(controller
                                          .subordinates.value[i].avatar),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          controller
                                              .subordinates.value[i].email,
                                          style: MAIN_TEXT_STYLE_BLACK,
                                        ),
                                        Text(
                                          controller
                                              .subordinates.value[i].login,
                                          style: MAIN_TEXT_STYLE_BLACK,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
