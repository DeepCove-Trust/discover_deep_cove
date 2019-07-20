import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/widgets/misc/tile.dart';
import 'package:flutter/material.dart';

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
  }

  Future<void> refreshData() async {
    List<Quiz> data = await quizBean.getAllAndPreload();
    setState(() => quizzes = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: quizzes.length > 0
          ? ListView(children: buildCards(context, quizzes))
          : Center(child: CircularProgressIndicator()),
    );
  }

  List<TileOld> buildCards(BuildContext context, List<Quiz> quizzes) {
    return quizzes.map((quiz) {
      return TileOld(
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
