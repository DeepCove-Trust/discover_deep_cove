import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final bool hasOnOff;
  final bool initalValue;
  final void Function(bool) onOffCallback;

  SettingsButton({
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
              padding: EdgeInsets.symmetric(
                horizontal: Screen.width(context, percentage: 10),
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: Screen.isTablet(context) ? 36 : 24,
              ),
            ),
            Container(
              child:
                  Screen.isTablet(context) ? SubHeading(text) : BodyText(text),
            ),
            hasOnOff == true
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Screen.width(context, percentage: 2.5),
                    ),
                    child: Switch(
                      onChanged: hasOnOff ? onOffCallback : null,
                      activeColor: Theme.of(context).primaryColor,
                      value: initalValue,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
