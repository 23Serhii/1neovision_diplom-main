import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neovision_flutter/constants/text_styles.dart';
import 'package:neovision_flutter/global_widgets/rounded_container.dart';

class SessionProperty extends StatelessWidget {
  const SessionProperty({
    super.key,
    required this.text,
    required this.onTap,
    required this.iconData,
    this.count = 0,
  });

  final String text;
  final String iconData;
  final Function() onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      onTap: onTap,
      color: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconData,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: MAIN_TEXT_STYLE_WHITE,
            ),
            const SizedBox(
              width: 10,
            ),
            Visibility(
              visible: count > 0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Center(
                  child: Text(
                    count.toString(),
                    style: MAIN_TEXT_STYLE_BLACK,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
