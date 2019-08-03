import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/widgets/quiz/image_question.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_text_button.dart';
import 'package:discover_deep_cove/widgets/quiz/text_only_question.dart';
import 'package:discover_deep_cove/widgets/quiz/text_question.dart';
import 'package:flutter/material.dart';

class QuizQuestionView extends StatelessWidget {
  final QuizQuestion question;
  final void Function(int) callBack;

  bool get hasMainImage => question.image != null;

  bool get hasImageAnswers => question.answers.any((a) => a.image != null);

  QuizQuestionView({@required this.question, @required this.callBack});

  void returnAnswer(int answerId) {
    callBack(answerId);
  }

  @override
  Widget build(BuildContext context) {
    if (hasMainImage) {
      return TextQuestion(question: question, answers: buildAnswerTiles());
    }

    if (hasImageAnswers) {
      return ImageQuestion(question: question, answers: buildAnswerTiles());
    }

    return TextOnlyQuestion(question: question, answers: buildAnswerTiles());
  }

  List<Widget> buildAnswerTiles() {
    if (question.trueFalseQuestion != null) {
      return [
        QuizTextButton(onTap: () => returnAnswer(1), text: 'True'),
        QuizTextButton(onTap: () => returnAnswer(0), text: 'False')
      ];
    }

    return hasImageAnswers
        ? question.answers.map((answer) {
            return QuizImageButton(
              onTap: () => returnAnswer(answer.id),
              imagePath: answer.image.path,
              text: answer.text,
            );
          }).toList()
        : question.answers.map((answer) {
            return QuizTextButton(
              onTap: () => returnAnswer(answer.id),
              text: answer.text,
            );
          }).toList();
  }
}
