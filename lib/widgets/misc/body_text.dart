import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  final String text;
  final TextAlign align;

  ///Returns a custom [Text] widget for accessing body1 theme
  ///and has an optional alignment property.
  BodyText({this.text, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.body1,
      textAlign: align,
    );
  }
}