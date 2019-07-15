import 'package:flutter/material.dart';
import 'package:discover_deep_cove/data/sample_data_quiz.dart';
import 'package:discover_deep_cove/util/heading_text.dart';
import 'package:discover_deep_cove/views/quiz/quiz_result.dart';
import 'package:discover_deep_cove/widgets/quiz/text_question.dart';
import 'package:discover_deep_cove/widgets/quiz/image_question.dart';
import 'package:discover_deep_cove/widgets/quiz/correct_wrong_overlay.dart';

class QuizQuestions extends StatefulWidget {
  final Quiz quiz;

  ///Takes in a [Quiz] and displays the questions.
  QuizQuestions({this.quiz});

  @override
  _QuizQuestionsState createState() => _QuizQuestionsState();
}

class _QuizQuestionsState extends State<QuizQuestions> {
  Widget currentQuestion;
  int index = 0;
  int score = 0;
  bool overlayVisible = false;
  bool appbarVisible = true;
  bool isCorrect;
  String guess;
  String answer;

  ///takes in an [int] answerID and determines if it is the correct answer
  ///factoring in whether it is a true/false, image or text based question
  void handleAnswer(int answerId) {
    isCorrect = (widget.quiz.questions[index].correctAnswerId == answerId);

    this.setState(() {
      overlayVisible = true;
      if (widget.quiz.questions[index].trueFalseAnswer) {
        guess = answerId == 0 ? "No" : "Yes";
        answer =
            widget.quiz.questions[index].correctAnswerId == 0 ? "No" : "Yes";
      } else if (widget.quiz.questions[index].image != null) {
        guess = widget.quiz.questions[index].answers[answerId].text;
        answer = widget.quiz.questions[index]
            .answers[widget.quiz.questions[index].correctAnswerId].text;
      } else {
        guess =
            widget.quiz.questions[index].answers[answerId].image.description;
        answer = widget
            .quiz
            .questions[index]
            .answers[widget.quiz.questions[index].correctAnswerId]
            .image
            .description;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarVisible ? AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: HeadingText(
          text:widget.quiz.title,
        ),
        centerTitle: true,
        leading: Container(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: HeadingText(
              text:"${index + 1}/${widget.quiz.questions.length}",
            ),
          ),
        ],
      ) : null,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          currentQuestion = getQuestion(),
          overlayVisible
              ? CorrectWrongOverlay(
                  isCorrect: isCorrect,
                  guess: guess,
                  answer: answer,
                  onTap: () {
                    if (isCorrect) score++;
                    index++;

                    setState(() {
                      overlayVisible = false;
                    });
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  //TODO figure out a way to get the correct answer and the guess when answers is shuffled
  //figure out a better way to handle answers when shuffled

  ///Returns the appropriate view to display depending on whether the [quiz] has ended or has more questions.
  Widget getQuestion() {
    //if (widget.quiz.questions[index].answers != null) widget.quiz.questions[index].answers.shuffle();

    if (index == widget.quiz.questions.length) {
      bool newHighscore = score > widget.quiz.highScore;

      if (score > widget.quiz.highScore) widget.quiz.highScore = score;

      return QuizResult(
        name: widget.quiz.title,
        score: score,
        outOf: widget.quiz.questions.length,
        highscore: newHighscore,
      );
    } else if (widget.quiz.questions[index].image != null) {
      if(widget.quiz.questions.length - index == 1) setState(() =>  appbarVisible = false);

      return TextQuestion(
        question: widget.quiz.questions[index],
        onTaps: [
          () => handleAnswer(0),
          () => handleAnswer(1),
          () => handleAnswer(2),
          () => handleAnswer(3),
        ],
      );
    } else {
      if(widget.quiz.questions.length - index == 1) setState(() =>  appbarVisible = false);

      return ImageQuestion(
        question: widget.quiz.questions[index],
        onTaps: [
          () => handleAnswer(0),
          () => handleAnswer(1),
          () => handleAnswer(2),
          () => handleAnswer(3),
        ],
      );
    }
  }
}
