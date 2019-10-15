import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:flutter/material.dart';

class QuizViewArgs {
  final Quiz quiz;
  final VoidCallback onComplete;

  QuizViewArgs({@required this.quiz, @required this.onComplete});
}