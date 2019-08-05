import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';
class SubHeading  extends StatelessWidget {
  final String text;
  final TextAlign align;

  ///Returns a custom [Text] widget for accessing headline theme
  ///and has an optional alignment property.
  SubHeading(this.text, {this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subhead.copyWith(
        fontSize: Screen.width(context) <= 350 ? 20 : 25,
      ),
      textAlign: align,
    );
  }
}