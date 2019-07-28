import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/handleOrientation.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizIndex extends StatefulWidget {
  @override
  State createState() => _QuizIndexState();
}

class _QuizIndexState extends State<QuizIndex> {
  QuizBean quizBean;
  List<Quiz> quizzes = List<Quiz>();

  @override
  void initState() {
    quizBean = QuizBean.of(context);
    refreshData();

    super.initState();
  }

  Future<void> refreshData() async {
    List<Quiz> data = await quizBean.getAllAndPreload();
    setState(() => quizzes = data);
  }

  @override
  Widget build(BuildContext context) {
    Screen.width(context) >= 600
        ? handleOrientation([
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ])
        : handleOrientation([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: quizzes.length > 0
          ? GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              crossAxisCount: (Screen.width(context) >= 600 &&
                      Screen.orientation(context) == Orientation.landscape)
                  ? 3
                  : (Screen.width(context) >= 600 &&
                          Screen.orientation(context) == Orientation.portrait)
                      ? 2
                      : 1,
              padding: EdgeInsets.all(20.0),
              children: buildCards(context, quizzes),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  List<Tile> buildCards(BuildContext context, List<Quiz> quizzes) {
    return quizzes.map((quiz) {
      return Tile(
        onTap: () {
          quiz.attempts++;
          Navigator.of(context).pushNamed('/quizQuestions', arguments: quiz);
        },
        title: quiz.title,
        subheading: quiz.attempts > 0
            ? 'High Score: ${quiz.highScore}/${quiz.questions.length} | Attempts: ${quiz.attempts}'
            : 'Not yet attempted',
        imagePath:
            quiz.image != null ? Env.getResourcePath(quiz.image.path) : null,
      );
    }).toList();
  }
}
