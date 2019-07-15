import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/data/sample_data_quiz.dart';
import 'package:discover_deep_cove/util/heading_text.dart';
import 'package:discover_deep_cove/widgets/misc/tile.dart';
import 'package:uuid/uuid.dart';

class QuizIndex extends StatefulWidget {
  @override
  _QuizIndexState createState() => _QuizIndexState();
}

class _QuizIndexState extends State<QuizIndex> {
  final Uuid uuid = Uuid();

  bool checkUnlocked() {
    for (Quiz quiz in quizzes) {
      if (quiz.unlocked) {
        return true;
      }
    }

    return false;
  }

  ///Builds the Quiz [tiles] if the quiz is unlocked or allows the user to unlock quizzes if
  ///there is none
  List<Tile> _buildGridCards(int count, BuildContext context) {
    List<Tile> cards = List();
    //String heroTag = uuid.v4();
    for (Quiz quiz in quizzes) {
      if (quiz.unlocked) {
        cards.add(
          Tile(
            onTap: () {
              quiz.attempts++;
              Navigator.pushNamed(
                context,
                '/quizQuestions',
                arguments: quiz,
              );
            },
            quiz: quiz,
            hero: uuid.v4(),
            height: (MediaQuery.of(context).size.height / 100) * 10,
          ),
        );
      }
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: checkUnlocked()
          ? Container(
              child: GridView.count(
                crossAxisCount: 1,
                padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                childAspectRatio: 8.0 / 8.0,
                children: _buildGridCards(quizzes.length, context),
              ),
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: HeadingText(
                        text: "You haven't unlocked any quizzes yet...",
                        align: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height / 100) * 20,
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/quizUnlock');
                      },
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Unlock Quizzes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.lockOpen,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
