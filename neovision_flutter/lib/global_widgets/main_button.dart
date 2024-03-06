import 'package:flutter/material.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';

class MainButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  final bool isActive;
  final double width;
  final Color color;

  const MainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isActive = true,
    this.width = 0,
    this.color = NEO_COLOR,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool taped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isActive
          ? () {
              widget.onPressed();
            }
          : null,
      onTapDown: (w) {
        setState(() {
          taped = true;
        });
      },
      onTapUp: (w) {
        setState(() {
          taped = false;
        });
      },
      onTapCancel: () {
        setState(() {
          taped = false;
        });
      },
      child: Container(
        width: widget.width == 0 ? null : widget.width,
        height: 45.0,
        decoration: BoxDecoration(
          color: widget.isActive
              ? taped
                  ? widget.color.withOpacity(0.5)
                  : widget.color
              : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: widget.isActive
                ? MAIN_TEXT_STYLE_WHITE
                : MAIN_TEXT_STYLE_WHITE.copyWith(color: LIGHT_GRAY_TEXT),
          ),
        ),
      ),
    );
  }
}
