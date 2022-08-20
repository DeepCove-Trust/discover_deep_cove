import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';

import '../../database_adapter.dart';
import '../media_file.dart';
import 'quiz_question.dart';

part 'quiz_answer.jorm.dart';

class QuizAnswer {
  QuizAnswer();

  @PrimaryKey()
  int id;

  @BelongsTo(QuizQuestionBean)
  int quizQuestionId;

  @Column(isNullable: true)
  String text;

  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  @HasOne(QuizQuestionBean)
  QuizQuestion correctForQuestion;

  @IgnoreColumn()
  MediaFile image;
}

@GenBean()
class QuizAnswerBean extends Bean<QuizAnswer> with _QuizAnswerBean {
  QuizAnswerBean(Adapter adapter) : super(adapter);

  QuizAnswerBean.of(BuildContext context) : super(DatabaseAdapter.of(context));

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  QuizQuestionBean _quizQuestionBean;

  QuizQuestionBean get quizQuestionBean => _quizQuestionBean ?? QuizQuestionBean(adapter);

  final String tableName = 'quiz_answers';

  Future<QuizAnswer> preloadRelationships(QuizAnswer answer) async {
    answer = await preload(answer);
    if (answer.imageId != null) {
      answer.image = await mediaFileBean.find(answer.imageId);
    }
    return answer;
  }

  Future<List<QuizAnswer>> preloadAllRelationships(List<QuizAnswer> answers) async {
    for (QuizAnswer answer in answers) {
      answer = await preloadRelationships(answer);
    }
    return answers;
  }
}
