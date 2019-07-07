import 'package:flutter/material.dart';

class Body1Text extends StatelessWidget {
  final String text;
  final TextAlign align;

  ///Returns a custom [Text] widget for accessing body1 theme
  ///and has an optional alignment property.
  Body1Text({this.text, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.body1,
      textAlign: align,
    );
  }
}
