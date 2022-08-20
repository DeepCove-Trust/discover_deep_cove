import 'package:flutter/material.dart';

import '../../data/models/quiz/quiz.dart';

class QuizViewArgs {
  final Quiz quiz;
  final VoidCallback onComplete;

  QuizViewArgs({@required this.quiz, @required this.onComplete});
}
