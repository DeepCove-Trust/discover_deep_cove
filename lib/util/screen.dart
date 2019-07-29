import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'handleOrientation.dart';

class Screen {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static Orientation orientation(BuildContext context) =>
      MediaQuery.of(context).orientation;

  static double percentOfWidth(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width -
      (MediaQuery.of(context).size.width * (percent / 100));

  static double percentofHeight(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height -
      (MediaQuery.of(context).size.height * (percent / 100));

  static setOrientations(BuildContext context) =>
      Screen.width(context) >= 600
          ? handleOrientation([
              DeviceOrientation.portraitUp,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight
            ])
          : handleOrientation([DeviceOrientation.portraitUp]);
}
