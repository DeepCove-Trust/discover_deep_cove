import 'package:discover_deep_cove/widgets/misc/sub_heading.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SettingsButton({this.icon, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Transform.scale(
              scale: 1.5,
              child: Container(
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width * 0.75),
              child: SubHeading(
                text: text,
                align: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}