import 'package:flutter/material.dart';

class Screen {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>MediaQuery.of(context).size.height;

  static Orientation orientation(BuildContext context) => MediaQuery.of(context).orientation;
}
