import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'handleOrientation.dart';

class Screen {
  static double width({BuildContext context, double percentage = 100}) =>
      MediaQuery.of(context).size.width / 100 * percentage;

  static double height({BuildContext context, double percentage = 100}) =>
      MediaQuery.of(context).size.height / 100 * percentage;

  static Orientation orientation(BuildContext context) =>
      MediaQuery.of(context).orientation;

  static setOrientations(BuildContext context) => Screen.width(context: context) >= 600
      ? handleOrientation([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ])
      : handleOrientation([DeviceOrientation.portraitUp]);

  static bool isPortrait(BuildContext context) =>
      Screen.orientation(context) == Orientation.portrait;
}
