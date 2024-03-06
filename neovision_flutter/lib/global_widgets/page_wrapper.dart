import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/global_widgets/custom_list_view.dart';
import 'package:neovision_flutter/global_widgets/page_padding.dart';

class PageWrapper extends StatelessWidget {
  final List<Widget> children;
  final Widget? header;
  final bool withBackground;
  final Widget? fab;
  final dynamic controller;
  final Color? color;
  final bool withListView;
  const PageWrapper(
      {super.key,
      required this.children,
      this.fab,
      this.color,
      this.controller,
      this.withBackground = false,
      this.header,
      this.withListView = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color ?? BG_COLOR,
      floatingActionButton: fab,
      body: Stack(children: [
        Visibility(
          visible: withBackground,
          child: Image.asset(
            "assets/images/background.gif",
            height: Get.height,
            width: Get.width,
            fit: BoxFit.fill,
          ),
        ),
        SafeArea(
          child: PagePadding(
            child: Column(
              children: [
                header ?? Container(),
                Expanded(
                  child: withListView
                      ? CustomListView(
                          controller: controller,
                          children: children,
                        )
                      : Column(
                          children: children,
                        ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
