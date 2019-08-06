import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  SettingsButton({this.text, this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Screen.height(context, percentage: 5), horizontal: 12),
        child: Row(
          mainAxisAlignment:
              Screen.width(context) >= 600 && Screen.isPortrait(context)
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.5, // Todo: Is this different to setting icon size?
              child: Icon(iconData, color: Colors.white),
            ),
            Container(
              width: Screen.width(context,
                  percentage:
                      Screen.width(context) >= 600 && Screen.isPortrait(context)
                          ? 60
                          : 30),
              child: SubHeading(text),
            )
          ],
        ),
      ),
    );
  }
}
