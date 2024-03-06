import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/global_widgets/rounded_button.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  final Widget? leftWidget;
  final Widget? middleWidget;
  final Widget? rightWidget;
  final double? height;

  bool withoutBack;

  Header(
      {super.key,
      this.leftWidget,
      this.middleWidget,
      this.rightWidget,
      this.height,
      this.withoutBack = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45.0,
      width: Get.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          leftWidget != null
              ? Positioned(
                  left: 0,
                  child: leftWidget!,
                )
              : withoutBack
                  ? const SizedBox(
                      width: 24.0,
                    )
                  : Positioned(
                      left: 0,
                      child: RoundedButton(
                        onTap: () {
                          Get.back(closeOverlays: true);
                        },
                        svgIcon: "assets/icons/arrow_back_icon.svg",
                      )),
          middleWidget ?? Container(),
          rightWidget != null
              ? Positioned(
                  right: 0,
                  child: rightWidget!,
                )
              : const SizedBox(
                  width: 24.0,
                ),
        ],
      ),
    );
  }
}
