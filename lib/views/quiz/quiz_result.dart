import 'package:flutter/material.dart';

import '../../util/screen.dart';
import '../../widgets/misc/bottom_back_button.dart';
import '../../widgets/misc/text/heading.dart';
import '../../widgets/misc/text/sub_heading.dart';

class QuizResult extends StatelessWidget {
  final String name;
  final int score;
  final int outOf;
  final bool isHighscore;

  ///takes in a [string], two [ints] and a bool and
  ///returns the view displaying the correct information.
  const QuizResult({this.name, this.score, this.outOf, this.isHighscore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildContent(context),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: const BottomBackButton(),
    );
  }

  setMessage() {
    if (score == outOf) {
      return "Congratulations, you got every question correct!";
    } else if (((score / outOf) * 100) >= 50) {
      return "Almost there, keep up the good work!";
    } else if (((score / outOf) * 100) >= 0 && ((score / outOf) * 100) <= 49) {
      return "You are improving, keep up the good work!";
    } else {
      return "You can do better, keep trying!";
    }
  }

  buildContent(BuildContext context) {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? Row(
            children: <Widget>[
              Expanded(child: getTopHalf(context)),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Expanded(
                    child: getBottomHalf(context),
                  )
                ],
              ))
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Expanded(child: getTopHalf(context)), Expanded(child: getBottomHalf(context))],
          );
  }

  getTopHalf(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Heading(name, size: Screen.isTablet(context) ? 55 : 35)),
        const SubHeading(
          "Quiz Completed!",
//          size: Screen.isTablet(context) ? 40 : null,
        ),
        SizedBox(
          height: Screen.height(context, percentage: 5.0),
        ),
      ],
    );
  }

  getBottomHalf(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Screen.isPortrait(context) ? 0 : 8.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: SubHeading(
                "Your score:",
              ),
            ),
            Heading(
              "$score/$outOf",
              size: Screen.isTablet(context) ? 100 : 75,
            ),
            isHighscore
                ? const SubHeading(
                    "New High Score!",
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SubHeading(
                setMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
