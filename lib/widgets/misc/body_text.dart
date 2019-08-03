import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  final String text;
  final TextAlign align;

  ///Returns a custom [Text] widget for accessing body1 theme
  ///and has an optional alignment property.
  BodyText(this.text, {this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: TextStyle(fontSize: Screen.width(context) <= 350 ? 16 : 20, color: Colors.white),
      textAlign: align,
    );
  }
}