import 'package:flutter/material.dart';
import 'package:hci_v2/util/heading_text.dart';

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
              width: (MediaQuery.of(context).size.width / 4) * 2.5,
              child: HeadingText(
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
