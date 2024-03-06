import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neovision_flutter/constants/colors.dart';
import 'package:neovision_flutter/constants/text_styles.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final String? text;
  final Function onChanged;

  const CustomCheckBox(
      {super.key, required this.isChecked, this.text, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          onChanged();
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: isChecked ? NEO_COLOR : BG_COLOR,
              child: CircleAvatar(
                backgroundColor: isChecked ? NEO_COLOR : Colors.white,
                radius: 13,
                child: isChecked
                    ? SvgPicture.asset('assets/icons/check_icon.svg')
                    : null,
              ),
            ),
            text != null
                ? Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        text!,
                        style: MAIN_TEXT_STYLE_BLACK,
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
