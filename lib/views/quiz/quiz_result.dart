import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:flutter/material.dart';

class QuizResult extends StatelessWidget {
  final String name;
  final int score;
  final int outOf;
  final bool isHighscore;

  ///takes in a [string], two [ints] and a bool and
  ///returns the view displaying the correct information.
  QuizResult({this.name, this.score, this.outOf, this.isHighscore});

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
      bottomNavigationBar: BottomBackButton(),
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
    return (Screen.width(context) >= 600 && !Screen.isPortrait(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getBottomHalf(context),
              getTopHalf(context),
            ],
          )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getTopHalf(context),
            getBottomHalf(context),
          ],
        );
  }

  getTopHalf(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Text(
            name,
            style: TextStyle(
              fontSize: Screen.width(context) <= 350 ? 30 : 60,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Screen.width(context) >= 600
            ? Heading(
                "Quiz Completed!",
              )
            : Body("Quiz Completed!"),
        SizedBox(
          height: Screen.height(context, percentage: 5.0),
        ),
      ],
    );
  }

  getBottomHalf(BuildContext context) {
   return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: Screen.height(context, percentage: 37.0),
            width: Screen.width(context,
                percentage: Screen.width(context) >= 600 ? 70 : 100),
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Screen.width(context) >= 600
                      ? Heading(
                          "Your score:",
                        )
                      : Body("Your score:"),
                ),
                Text(
                  "$score/$outOf",
                  style: TextStyle(
                    fontSize: Screen.width(context) <= 350 ? 40 : 100,
                    color: Colors.white,
                  ),
                ),
                isHighscore
                    ? Screen.width(context) >= 600
                        ? Heading("New Highscore!")
                        : Body("New Highscore!")
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Screen.width(context) >= 600
                      ? Heading(setMessage())
                      : Body(setMessage()),
                ),
              ],
            ),
          ),
        );
  }
}
