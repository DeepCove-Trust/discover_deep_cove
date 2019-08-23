import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screen {
  static double width(BuildContext context, {double percentage = 100}) =>
      MediaQuery.of(context).size.width / 100 * percentage;

  static double height(BuildContext context, {double percentage = 100}) =>
      MediaQuery.of(context).size.height / 100 * percentage;

  static Orientation orientation(BuildContext context) =>
      MediaQuery.of(context).orientation;

  static setOrientations(BuildContext context) => Screen.isTablet(context)
      ? SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ])
      : SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  static bool isPortrait(BuildContext context) =>
      Screen.orientation(context) == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      Screen.orientation(context) == Orientation.landscape;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.width <= 350;
}
