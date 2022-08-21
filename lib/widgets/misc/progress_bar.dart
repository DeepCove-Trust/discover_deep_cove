import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../util/screen.dart';

class ProgressBar extends StatelessWidget {
  final double percent;
  const ProgressBar({this.percent});

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
      backgroundColor: const Color(0xFF3B160D),
    );
  }
}
