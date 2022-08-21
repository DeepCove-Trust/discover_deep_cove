// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/quiz/quiz.dart';
import '../../util/screen.dart';
import '../../widgets/misc/text/sub_heading.dart';
import '../../widgets/quiz/quiz_tile.dart';
import 'quiz_view_args.dart';

class QuizIndex extends StatefulWidget {
  @override
  State createState() => _QuizIndexState();
}

class _QuizIndexState extends State<QuizIndex> {
  List<Quiz> quizzes;

  @override
  void initState() {
    super.initState();

    quizzes = PageStorage.of(context).readState(context, identifier: 'Quizzes');
    if (quizzes == null) refreshData();
  }

  Future<void> refreshData() async {
    List<Quiz> activeQuizzes = await QuizBean.of(context).getAllAndPreload();
    List<Quiz> unlockedQuizzes = activeQuizzes.where((q) => q.unlocked).toList();
    PageStorage.of(context).writeState(context, unlockedQuizzes, identifier: 'Quizzes');
    setState(() => quizzes = unlockedQuizzes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const SubHeading(
          'Deep Cove Trivia',
        ),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quizUnlock', arguments: refreshData);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.only(top: 7.0),
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
            ),
            child: Column(
              children: const <Widget>[
                Icon(
                  FontAwesomeIcons.lockOpen,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Unlock',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: quizzes == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => refreshData(),
              child: quizzes.isNotEmpty
                  ? GridView.count(
                      mainAxisSpacing: Screen.width(context, percentage: 2.5),
                      crossAxisSpacing: Screen.width(context, percentage: 2.5),
                      crossAxisCount: (Screen.isTablet(context)
                          ? Screen.isPortrait(context)
                              ? 2
                              : 3
                          : 1),
                      padding: EdgeInsets.all(
                        Screen.width(context, percentage: 2.5),
                      ),
                      children: buildCards(context, quizzes),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Future<void> addAttempt(Quiz quiz) async {
    quiz.setAttempts(quiz.attempts + 1);
    await QuizBean.of(context).update(quiz);
  }

  List<Tile> buildCards(BuildContext context, List<Quiz> quizzes) {
    return quizzes.map((quiz) {
      return Tile(
        onTap: () {
          addAttempt(quiz);
          Navigator.of(context)
              .pushNamed('/quizQuestions', arguments: QuizViewArgs(quiz: quiz, onComplete: refreshData));
        },
        title: quiz.title,
        subheading: quiz.attempts > 0
            ? 'High Score: ${quiz.highScore}/${quiz.questions.length} | Attempts: ${quiz.attempts}'
            : 'Not yet attempted',
        image: quiz.image != null ? quiz.image : null,
      );
    }).toList();
  }
}
