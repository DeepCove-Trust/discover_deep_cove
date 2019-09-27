import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final double percent;
  ProgressBar({this.percent});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      alignment: MainAxisAlignment.center,
      width: Screen.width(context, percentage: 60),
      animation: true,
      animateFromLastPercent: true,
//      lineHeight: 5.0,
//      animationDuration: 500,
      percent: percent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Theme.of(context).accentColor,
      backgroundColor: Color(0xFF3B160D),
    );
  }
}