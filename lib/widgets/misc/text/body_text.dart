import 'package:flutter/material.dart';

import '../../../util/screen.dart';

class BodyText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double size;
  final double height;

  ///Returns a custom [Text] widget for accessing body1 theme
  ///and has an optional alignment property.
  BodyText(this.text, {this.align = TextAlign.center, this.size, this.height = 1.5});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontSize: size ?? (Screen.isSmall(context) ? 16 : 20),
        color: Colors.white,
        height: height,
      ),
      textAlign: align,
    );
  }
}
