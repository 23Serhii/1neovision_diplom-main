import 'package:flutter/material.dart';
import 'package:neovision_flutter/constants/colors.dart';

class RoundedContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final Color color;
  final bool borderEnabled;
  final Color borderColor;
  final Function()? onTap;
  final bool fitted;

  const RoundedContainer({
    super.key,
    required this.child,
    this.height = 0,
    this.width = 0,
    this.color = BG_COLOR,
    this.borderEnabled = false,
    this.onTap,
    this.borderColor = DARK_BROWN,
    this.fitted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        onTap: onTap == null
            ? null
            : () {
                onTap!();
              },
        child: Container(
          height: height == 0 ? null : height,
          width: width == 0 ? null : width,
          decoration: BoxDecoration(
            color: color,
            border:
                borderEnabled ? Border.all(color: borderColor, width: 1) : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child:
              fitted ? FittedBox(fit: BoxFit.scaleDown, child: child) : child,
        ),
      ),
    );
  }
}
