import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';

class CustomFab extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  ///Returns an extended [FloatingActionButton] with the params
  ///icon, text and onPressed passed in
  const CustomFab({this.icon, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: Screen.isSmall(context) ? 0.75 : 1,
          child: FloatingActionButton.extended(
        icon: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 4.0, 0),
          child: Icon(icon),
        ),
        label: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 2.0, 8.0, 2.0),
          child: SubHeading(text),
        ),
        onPressed: onPressed,
        heroTag: null,
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
