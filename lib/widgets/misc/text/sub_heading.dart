import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double size;

  ///Returns a custom [Text] widget for accessing headline theme
  ///and has an optional alignment property.
  SubHeading(this.text, {this.align = TextAlign.center, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontSize: size ?? (Screen.isSmall(context) ? 20 : 25),
        color: Colors.white,
      ),
      textAlign: align,
    );
  }
}
