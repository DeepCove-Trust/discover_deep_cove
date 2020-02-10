import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/views/quiz/quiz_result.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:discover_deep_cove/widgets/quiz/correct_wrong_overlay.dart';
import 'package:discover_deep_cove/widgets/quiz/image_question.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_image_button.dart';
import 'package:discover_deep_cove/widgets/quiz/quiz_text_button.dart';
import 'package:discover_deep_cove/widgets/quiz/text_only_question.dart';
import 'package:discover_deep_cove/widgets/quiz/text_question.dart';
import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  QuizView({this.quiz, this.onComplete});

  final Quiz quiz;
  final VoidCallback onComplete;

  @override
  State createState() => QuizViewState();
}

class QuizViewState extends State<QuizView> {
  bool questionsLoaded = false;

  QuizQuestion get currentQuestion => widget.quiz.questions[questionIndex];
  bool isCorrect;
  String guess;
  String answer;
  QuizAnswer imageGuess;
  QuizAnswer imageAnswer;
  bool showOverlay = false;
  int questionIndex = 0;
  int score = 0;
  AudioPlayer questionAudio = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    widget.quiz.questions = await QuizQuestionBean.of(context)
        .preloadAllRelationships(widget.quiz.questions);
    setState(() => questionsLoaded = true);

    //Randomizes the order of the quiz questions
    if(widget.quiz.shuffle)widget.quiz.questions.shuffle();
  }

  Future<void> updateHighScore(int score) async {
    Quiz quiz = widget.quiz;
    quiz.setHighScore(score);
    await QuizBean.of(context).update(quiz);
  }

  void handleAnswer(int answerId) {
    if (currentQuestion.trueFalseAnswer != null) {
      isCorrect = answerId == (currentQuestion.trueFalseAnswer ? 1 : 0);
      guess = answerId == 0 ? "False" : "True";
      answer = currentQuestion.trueFalseAnswer ? "True" : "False";
    } else if (currentQuestion.answers.any((a) => a.image != null)) {
      isCorrect = answerId == currentQuestion.correctAnswerId;
      imageGuess = currentQuestion.answers.firstWhere((a) => a.id == answerId);
      imageAnswer = currentQuestion.answers
          .firstWhere((a) => a.id == currentQuestion.correctAnswerId);
    } else {
      isCorrect = answerId == currentQuestion.correctAnswerId;
      guess = currentQuestion.answers.firstWhere((a) => a.id == answerId).text;
      answer = currentQuestion.answers
          .firstWhere((a) => a.id == currentQuestion.correctAnswerId)
          .text;
    }

    if (isCorrect) score++;

    setState(() => showOverlay = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: questionIndex < widget.quiz.questions.length
          ? AppBar(
              brightness: Brightness.dark,
              title: SubHeading(
                widget.quiz.title,
                size: Screen.isTablet(context)
                    ? 30
                    : Screen.isSmall(context) ? 16 : 25,
              ),
              centerTitle: true,
              leading: Container(),
              actions: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SubHeading(
                      '${questionIndex + 1}/${widget.quiz.questions.length}',
                      size: Screen.isTablet(context)
                          ? 30
                          : Screen.isSmall(context) ? 16 : 25,
                    ),
                  ),
                )
              ],
              backgroundColor: Theme.of(context).primaryColor,
            )
          : null,
      body: questionsLoaded
          ? Stack(
              fit: StackFit.expand,
              children: [
                buildQuestionView(),
                if (showOverlay) buildOverlay(),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildQuestionView() {
    if (questionIndex == widget.quiz.questions.length) {
      bool isHighScore = false;
      if (widget.quiz.highScore == null || score > widget.quiz.highScore) {
        updateHighScore(score);
        isHighScore = true;
      }

      widget.onComplete();

      return QuizResult(
        name: widget.quiz.title,
        score: score,
        outOf: widget.quiz.questions.length,
        isHighscore: isHighScore,
      );
    }

    // if the question has an image
    if (currentQuestion.image != null) {
      return TextQuestion(
        question: currentQuestion,
        answers: buildAnswerTiles(),
        player: questionAudio,
      );
    }

    // if any answers have an image
    if (currentQuestion.answers.any((a) => a.image != null)) {
      return ImageQuestion(
        question: currentQuestion,
        answers: buildAnswerTiles(),
        player: questionAudio,
      );
    }

    // if the question/answers are text only
    return TextOnlyQuestion(
      question: currentQuestion,
      answers: buildAnswerTiles(),
      player: questionAudio,
    );
  }

  List<Widget> buildAnswerTiles() {
    if (currentQuestion.trueFalseAnswer != null) {
      return [
        QuizTextButton(onTap: () => handleAnswer(1), text: 'True'),
        QuizTextButton(onTap: () => handleAnswer(0), text: 'False')
      ];
    }

    //Randomizes the answers so the tiles are in different locations each time
    if(widget.quiz.shuffle)currentQuestion.answers.shuffle();

    // does the question have any image answers?
    return currentQuestion.answers.any((a) => a.image != null)
        ? currentQuestion.answers.map((answer) {
            return QuizImageButton(
              onTap: () => handleAnswer(answer.id),
              image: answer.image,
              text: answer.text,
            );
          }).toList()
        : currentQuestion.answers.map((answer) {
            return QuizTextButton(
              onTap: () => handleAnswer(answer.id),
              text: answer.text,
            );
          }).toList();
  }

  Widget buildOverlay() {
    questionAudio.stop();

    return CorrectWrongOverlay(
      isCorrect: isCorrect,
      guess: guess,
      answer: answer,
      imageGuess: imageGuess,
      imageAnswer: imageAnswer,
      onTap: () => setState(() {
        imageAnswer = null;
        imageGuess = null;
        questionIndex++;
        showOverlay = false;
      }),
    );
  }
}
