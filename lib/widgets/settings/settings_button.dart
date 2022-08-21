import 'package:flutter/material.dart';

import '../../util/screen.dart';
import '../misc/text/body_text.dart';
import '../misc/text/heading.dart';

class SettingsButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final bool hasOnOff;
  final bool initalValue;
  final void Function(bool) onOffCallback;

  const SettingsButton({
    this.text,
    this.iconData,
    this.onTap,
    this.hasOnOff,
    this.initalValue,
    this.onOffCallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Screen.height(context, percentage: 2.5),
          horizontal: 12,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Screen.width(context, percentage: Screen.isLandscape(context) ? 25 : 10), 0,
                  Screen.width(context, percentage: 10), 0),
              child: Icon(
                iconData,
                color: Colors.white,
                size: Screen.isTablet(context) ? 36 : 24,
              ),
            ),
            Container(
              child: Screen.isTablet(context)
                  ? Heading(text)
                  : BodyText(
                      text,
                      size: Screen.isSmall(context) ? 13.5 : null,
                    ),
            ),
            hasOnOff == true
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Screen.width(context, percentage: 2.5),
                    ),
                    child: Transform.scale(
                      scale: Screen.isTablet(context) ? 1.5 : 1,
                      child: Switch(
                        onChanged: hasOnOff ? onOffCallback : null,
                        activeColor: Theme.of(context).primaryColor,
                        value: initalValue,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
