import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundedButton extends StatelessWidget {
  final void Function()? onTap;
  final String? svgIcon;
  final String? imageIcon;
  final Color color;
  const RoundedButton({
    Key? key,
    required this.onTap,
    this.imageIcon,
    this.svgIcon,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      onTap: onTap,
      child: SizedBox(
        height: 43,
        width: 43,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: svgIcon != null
              ? SvgPicture.asset(
                  svgIcon!,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                )
              : Image.asset(
                  imageIcon!,
                  color: color,
                ),
        ),
      ),
    );
  }
}
