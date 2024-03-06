import 'package:flutter/material.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/global_widgets/loader_indicator.dart';

class LoadingPage extends StatelessWidget {
  static String id = "/loading";
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BG_COLOR,
      child: Center(
        child: LoaderIndicator(),
      ),
    );
  }
}
