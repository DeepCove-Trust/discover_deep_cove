import 'dart:io';

import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
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
  List<Quiz> quizzes;

  @override
  void initState() {
    quizBean = QuizBean.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
          onRefresh: refreshQuizzes,
          child: ListView(
              children: [Column(children: quizzes != null ? buildCards(context, quizzes) : [Text('Pull down to refresh...')])])),
    );
  }

  Future<void> refreshQuizzes() async {
    quizzes = await quizBean.getAllAndPreload();
    setState(() {});
  }

  List<Tile> buildCards(BuildContext context, List<Quiz> quizzes) {
    return quizzes.map((quiz) {
      return Tile(
          onTap: () {
            quiz.attempts++;
            Navigator.pushNamed(
              context,
              '/quizQuestions',
              arguments: quiz,
            );
          },
          quiz: quiz,
          hero: quiz.id.toString(),
          height: (MediaQuery.of(context).size.width / 10) * 2);
    }).toList(growable: false);
  }
}
