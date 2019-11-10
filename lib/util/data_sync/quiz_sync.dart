import 'dart:convert';

import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/network_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;

import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';

class QuizData {
  int id;
  String title;
  DateTime updatedAt;

  QuizData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    updatedAt = DateTime.parse(map['updated_at']);
  }
}

class QuizSync {
  final CmsServerLocation server;
  final QuizBean quizBean;
  final QuizQuestionBean questionBean;
  final QuizAnswerBean answerBean;

  QuizSync(SqfliteAdapter adapter, {@required this.server})
      : quizBean = QuizBean(adapter),
        questionBean = QuizQuestionBean(adapter),
        answerBean = QuizAnswerBean(adapter);

  Future<void> sync() async {
    // Summary of local quizzes
    List<Quiz> localQuizzes = await quizBean.getAll();

    // Get summary of active quizzes
    List<QuizData> serverQuizzes = await _getQuizSummary();

    // Get set of all IDs on both remote and local databases
    Set<int> idSet = localQuizzes
        .map((q) => q.id)
        .toSet()
        .union(serverQuizzes.map((q) => q.id).toSet());

    List<Future> futures = List<Future>();

    for (int id in idSet) {
      // If local quizzes doesn't have a copy, download from server
      if (!localQuizzes.any((q) => q.id == id)) {
        if(Env.asyncDownload){
          futures.add(_downloadQuizData(id));
        } else {
          await _downloadQuizData(id);
        }
      }
      // If server doesn't send this quiz, and the local database contains it,
      // delete it and all its children records
      else if (!serverQuizzes.any((q) => q.id == id)) {
        await _deleteQuiz(id);
      }
      // Otherwise, both local and server have the quiz - if the server quiz
      // is newer, replace the local one.
      else if (serverQuizzes
          .firstWhere((q) => q.id == id)
          .updatedAt
          .isAfter(localQuizzes.firstWhere((q) => q.id == id).updatedAt)) {
        if(Env.asyncDownload){
          futures.add(_replaceQuizData(id));
        }
        else {
          await _replaceQuizData(id);
        }
      }
    }

    if(Env.asyncDownload){
      await Future.wait(futures);
      print('Aysnc quiz downloads complete');
    }
  }

  /// Return list of QuizData objects, representing the active quizzes on
  /// the CMS server.
  Future<List<QuizData>> _getQuizSummary() async {
    // Request summary
    String jsonString =
        await NetworkUtil.requestDataString(Env.quizzesUrl(server));
    List<dynamic> decodedJson = json.decode(jsonString);
    return decodedJson.map((map) => QuizData.fromMap(map)).toList();
  }

  Future<void> _downloadQuizData(int id, {bool unlocked}) async {
    // Request full json string of quiz and all questions/answers
    String jsonString =
        await NetworkUtil.requestDataString(Env.quizDetailsUrl(server, id));
    Map<String, dynamic> map = json.decode(jsonString);

    // Deserialize quiz object
    Quiz quiz = quizBean.fromMap(map);

    // Deserialize question objects
    List<dynamic> questionData = map['questions'];
    List<QuizQuestion> questions =
        questionData.map((map) => questionBean.fromMap(map)).toList();

    // Deserialize answer objects for each question
    List<QuizAnswer> answers = List<QuizAnswer>();
    for (Map<String, dynamic> map in questionData) {
      List<dynamic> answerData = map['answers'];
      answers.addAll(answerData.map((map) => answerBean.fromMap(map)).toList());
    }

    // Insert quiz into database, unlocking if appropriate
    quiz.setUnlocked(unlocked);
    await quizBean.insert(quiz, onlyNonNull: true);

    // Insert questions (we have to withhold correct answer IDs until the
    // answers have been inserted, to dodge FK constraint
    for (QuizQuestion question in questions) {
      int correctAnswerId = question.correctAnswerId;
      question.correctAnswerId = null;
      await questionBean.insert(question);

      // Insert answers for this question
      if( answers.where((a) => a.quizQuestionId == question.id).isNotEmpty){
        await answerBean.insertMany(answers.where((a) => a.quizQuestionId == question.id).toList());
      }

      // Now replace the correct answer id for the question
      question.correctAnswerId = correctAnswerId;
      await questionBean.update(question);
    }

    print('Downloaded quiz $id (${quiz.title})');
  }

  /// Deletes the given quiz ID, as well as all question and answer records
  /// related to it.
  Future<void> _deleteQuiz(int id) async {
    // Fetch the quiz object from database
    Quiz quiz = await quizBean.find(id);

    List<QuizQuestion> questions = await questionBean.findByQuiz(id);

    // Delete all questions and answers
    for (QuizQuestion question in questions) {
      question.correctAnswerId = null;
      await questionBean.update(question);

      List<QuizAnswer> answers =
          await answerBean.findByQuizQuestion(question.id);
      for (QuizAnswer answer in answers) {
        await answerBean.remove(answer.id);
      }
      questionBean.remove(question.id);
    }

    // Delete the quiz itself
    await quizBean.remove(id);

    print('Deleted quiz $id (${quiz.title}');
  }

  /// Deletes and re-downloads the given quiz ID, persisting the unlock state
  /// of the original.
  Future<void> _replaceQuizData(int id) async {
    Quiz quiz = await quizBean.find(id);
    print('Updating quiz $id (${quiz.title} - (will delete and re-download');
    await _deleteQuiz(id);
    await _downloadQuizData(id, unlocked: quiz.unlocked);
  }
}
