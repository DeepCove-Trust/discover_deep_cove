import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_text_button.dart';
import 'package:flutter/material.dart';

abstract class QuizQuestionView extends StatelessWidget {
  final QuizQuestion question;
  bool get hasMainImage => question.image != null;
  bool get hasImageAnswers => question.answers.any((a) => a.image != null);

  QuizQuestionView({this.question});

  @override
  Widget build(BuildContext context) {}

  List<Widget> buildAnswerTiles() {
    return question.answers.map((answer) {
      return hasImageAnswers ? QuizImageButton() : QuizTextButton(); // todo
    }).toList();
  }

  GridView buildGrid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      children: buildAnswerTiles(),
    );
  }
}
