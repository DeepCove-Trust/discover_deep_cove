import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';

import '../../database_adapter.dart';
import '../media_file.dart';
import 'quiz.dart';
import 'quiz_answer.dart';

part 'quiz_question.jorm.dart';

class QuizQuestion {
  QuizQuestion();

  @PrimaryKey()
  int id;

  @BelongsTo(QuizBean)
  int quizId;

  @Column(name: 'trueFalseAnswer', isNullable: true)
  int _trueFalseAnswer;

  @IgnoreColumn()
  bool get trueFalseAnswer => _trueFalseAnswer != null ? _trueFalseAnswer == 1 : null;

  @Column()
  String text;

  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  @BelongsTo(MediaFileBean, isNullable: true)
  int audioId;

  @HasMany(QuizAnswerBean)
  List<QuizAnswer> answers;

  @BelongsTo(QuizAnswerBean, isNullable: true)
  int correctAnswerId;

  @IgnoreColumn()
  MediaFile image;

  @IgnoreColumn()
  MediaFile audio;

  @IgnoreColumn()
  QuizAnswer correctAnswer; // Todo: Don't think we need this one
}

@GenBean()
class QuizQuestionBean extends Bean<QuizQuestion> with _QuizQuestionBean {
  QuizQuestionBean(Adapter adapter)
      : quizAnswerBean = QuizAnswerBean(adapter),
        super(adapter);

  QuizQuestionBean.of(BuildContext context)
      : quizAnswerBean = QuizAnswerBean(DatabaseAdapter.of(context)),
        super(DatabaseAdapter.of(context));

  final QuizAnswerBean quizAnswerBean;

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  QuizBean _quizBean;

  QuizBean get quizBean => _quizBean ?? QuizBean(adapter);

  final String tableName = 'quiz_questions';

  Future<QuizQuestion> preloadRelationships(QuizQuestion question) async {
    question = await preload(question);
    if (question.imageId != null) {
      question.image = await mediaFileBean.find(question.imageId);
    }
    if (question.audioId != null) {
      question.audio = await mediaFileBean.find(question.audioId);
    }
    question.answers = await quizAnswerBean.preloadAllRelationships(question.answers);
    return question;
  }

  Future<List<QuizQuestion>> preloadAllRelationships(List<QuizQuestion> questions) async {
    for (QuizQuestion question in questions) {
      question = await preloadRelationships(question);
    }
    return questions;
  }
}
