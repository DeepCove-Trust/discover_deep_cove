import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double size;

  ///Returns a custom [Text] widget for accessing body1 theme
  ///and has an optional alignment property.
  Body(this.text, {this.align = TextAlign.center, this.size = 0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontSize: size == 0 ? Screen.isSmall(context) ? 16 : 20 : size,
        color: Colors.white,
      ),
      textAlign: align,
    );
  }
}
