import 'package:flutter/material.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';

// ignore: must_be_immutable
class CustomInput extends StatelessWidget {
  final String? hintText;
  final double height;
  final double width;
  final bool borderEnabled;
  final bool isPassword;
  final bool enabled;
  final controller;
  final color;
  final keyboardType;
  final inputFormatters;
  final focusNode;
  final onChanged;
  final initialValue;
  final style;

  CustomInput(
      {this.hintText,
      this.color,
      this.height = 54,
      this.width = 200,
      this.borderEnabled = false,
      this.isPassword = false,
      this.controller,
      this.enabled = true,
      this.focusNode,
      this.inputFormatters,
      this.keyboardType,
      this.onChanged,
      this.initialValue,
      this.style = MAIN_TEXT_STYLE_BLACK});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: color == null ? Colors.white : color,
      borderEnabled: borderEnabled,
      width: width,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            enabled: enabled,
            keyboardType: keyboardType,
            focusNode: focusNode, textInputAction: TextInputAction.done,
            inputFormatters: inputFormatters,
            obscureText: isPassword,
            minLines: 1,
            maxLines: isPassword ? 1 : null, // This will make it auto-expand
            style: style,
            cursorColor: DARK_BROWN,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: MAIN_TEXT_STYLE_BLACK.copyWith(
                color: LIGHT_GRAY_TEXT,
              ),
              border: InputBorder.none,
            ),
            controller: controller,
            onChanged: onChanged,
            initialValue: initialValue,
          ),
        ),
      ),
    );
  }
}
