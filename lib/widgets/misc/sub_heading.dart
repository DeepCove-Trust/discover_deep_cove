import 'package:flutter/material.dart';
class SubHeading  extends StatelessWidget {
  final String text;
  final TextAlign align;

  ///Returns a custom [Text] widget for accessing headline theme
  ///and has an optional alignment property.
  SubHeading(this.text, {this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subhead,
      textAlign: align,
    );
  }
}