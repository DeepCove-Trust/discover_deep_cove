import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  SettingsButton({
    this.text,
    this.iconData,
    this.onTap,
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
          ],
        ),
      ),
    );
  }
}
