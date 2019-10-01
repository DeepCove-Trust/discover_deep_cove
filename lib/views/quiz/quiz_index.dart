import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuizIndex extends StatefulWidget {
  @override
  State createState() => _QuizIndexState();
}

class _QuizIndexState extends State<QuizIndex> {
  List<Quiz> quizzes = List<Quiz>();

  @override
  void initState() {
    refreshData();

    super.initState();
  }

  Future<void> refreshData() async {
    List<Quiz> activeQuizzes = await QuizBean.of(context).getAllAndPreload();
    activeQuizzes = activeQuizzes.where((quiz) => quiz.unlocked).toList();
    setState(() => quizzes = activeQuizzes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: SubHeading(
          'Deep Cove Trivia',
          size: Screen.isTablet(context)
              ? 30
              : Screen.isSmall(context) ? 16 : null,
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quizUnlock',
                  arguments: refreshData);
            },
            color: Colors.transparent,
            padding: EdgeInsets.only(top: 7.0),
            child: Column(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.lockOpen,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Unlock",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        brightness: Brightness.dark,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => refreshData(),
        child: quizzes.length > 0
            ? GridView.count(
                mainAxisSpacing: Screen.width(context, percentage: 2.5),
                crossAxisSpacing: Screen.width(context, percentage: 2.5),
                crossAxisCount: (Screen.isTablet(context)
                    ? Screen.isPortrait(context) ? 2 : 3
                    : 1),
                padding: EdgeInsets.all(
                  Screen.width(context, percentage: 2.5),
                ),
                children: buildCards(context, quizzes),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> addAttempt(Quiz quiz) async {
    quiz.attempts++;
    await QuizBean.of(context).update(quiz);
  }

  List<Tile> buildCards(BuildContext context, List<Quiz> quizzes) {
    return quizzes.map((quiz) {
      return Tile(
        onTap: () {
          addAttempt(quiz);
          Navigator.of(context).pushNamed('/quizQuestions', arguments: quiz);
        },
        title: quiz.title,
        subheading: quiz.attempts > 0
            ? 'High Score: ${quiz.highScore}/${quiz.questions.length} | Attempts: ${quiz.attempts}'
            : 'Not yet attempted',
        image: quiz.image != null ? quiz.image : null ,
      );
    }).toList();
  }
}
