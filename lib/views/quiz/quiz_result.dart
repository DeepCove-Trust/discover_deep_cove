import 'package:flutter/material.dart';
import 'package:hci_v2/util/body1_text.dart';
import 'package:hci_v2/widgets/back_nav_bottom.dart';

class QuizResult extends StatelessWidget {
  final String name;
  final int score;
  final int outOf;
  final bool highscore;  

  ///takes in a [string], two [ints] and a bool and
  ///returns the view displaying the correct information.
  QuizResult({this.name, this.score, this.outOf, this.highscore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
              ),
              Body1Text(
                text: "Quiz Completed!",
                align: TextAlign.center,
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.width / 10) * 1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: (MediaQuery.of(context).size.width / 10) * 7,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Body1Text(
                          text: "Your Score:",
                        ),
                      ),
                      Text(
                        "$score/$outOf",
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 100),
                      ),
                      highscore
                          ? Body1Text(
                              text: "New Highscore!",
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Body1Text(
                          text: setMessage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          BackNavBottom(),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  setMessage() {
    if(score == outOf){
      return "Congratulations you got every question correct!";
    }else if(((score / outOf) * 100) >= 50){
      return "Almost there keep up the good work!";
    }else if (((score / outOf) * 100) >= 0 && ((score / outOf) * 100) <= 49){
      return "You are improving keep up the good work";
    }else{
      return "You can do better, keep trying!";
    }
  }
}
