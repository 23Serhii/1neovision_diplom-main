import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/constants/text_styles.dart';

class LoaderIndicator extends StatelessWidget {
  const LoaderIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset(
        //   "assets/images/run.gif",
        //   color: ORIENT_COLOR,
        //   height: 100,
        // ),
        Material(
          color: Colors.transparent,
          child: Text(
            "Loading..".tr,
            style: MAIN_TEXT_STYLE_WHITE.copyWith(fontSize: 14),
          ),
        )
      ],
    );
  }
}
