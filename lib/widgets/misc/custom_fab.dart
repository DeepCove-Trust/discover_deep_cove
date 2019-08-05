import 'package:flutter/material.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';

class CustomFab extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  ///Returns an extended [FloatingActionButton] with the params
  ///icon, text and onPressed passed in
  const CustomFab({this.icon, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 4.0, 0),
        child: Icon(icon),
      ),
      label: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 2.0, 8.0, 2.0),
        child: Body(
           text,
        ),
      ),
      onPressed: onPressed,
      heroTag: null,
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
