import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final bool isOnOff;
  final bool initalValue;
  final void Function(bool) onOffCallback;

  SettingsButton({
    this.text,
    this.iconData,
    this.onTap,
    this.isOnOff = false,
    this.initalValue = false,
    this.onOffCallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isOnOff ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Screen.height(context, percentage: 5), horizontal: 12),
        child: Row(
          mainAxisAlignment: Screen.isLandscape(context)
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
          children: [
            Transform.scale(
              scale: 1.5, // Todo: Is this different to setting icon size?
              child: Icon(iconData, color: Colors.white),
            ),
            Container(
              width: Screen.width(context,
                  percentage:
                      Screen.isTablet(context) && Screen.isPortrait(context)
                          ? 60
                          : 40),
              child: SubHeading(text),
            ),
            isOnOff
                ? Switch(
                    onChanged: isOnOff ? onOffCallback : null,
                    activeColor: Theme.of(context).accentColor,
                    value: initalValue,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
