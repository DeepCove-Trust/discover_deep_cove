import 'package:flutter/material.dart';

import '../../../util/screen.dart';

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
        fontSize: size ?? (Screen.isSmall(context) ? 20 : 30),
        color: Colors.white,
      ),
      textAlign: align,
    );
  }
}
