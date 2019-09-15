import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';

part 'quiz.jorm.dart';

class Quiz {
  Quiz();

  @PrimaryKey()
  int id;

  @Column()
  DateTime lastModified;

  // todo: wait for jaguar to support default values
  @Column(name: 'unlocked', isNullable: true)
  bool unlocked;

  /// Returns true if the quiz is unlocked. This also takes into consideration
  /// whether there is an unlock code set (quiz is unlocked by default if no
  /// unlock code is set).
//  @IgnoreColumn()
//  bool get unlocked => unlockCode == null ? true : (_unlocked ?? false);

  @Column(isNullable: true)
  String unlockCode;

  @Column()
  String title;

  @Column(isNullable: true)
  int attempts;

  @Column(isNullable: true)
  int highScore;

  @HasMany(QuizQuestionBean)
  List<QuizQuestion> questions;

  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  @IgnoreColumn()
  MediaFile image;

  clearProgress(){
    attempts = 0;
    highScore = 0;
    unlocked = unlockCode == null;
  }
}

@GenBean()
class QuizBean extends Bean<Quiz> with _QuizBean {
  QuizBean(Adapter adapter)
      : quizQuestionBean = QuizQuestionBean(adapter),
        super(adapter);

  QuizBean.of(BuildContext context)
      : quizQuestionBean = QuizQuestionBean(DatabaseAdapter.of(context)),
        super(DatabaseAdapter.of(context));

  final QuizQuestionBean quizQuestionBean;

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'quizzes';
  
  Future<List<Quiz>> preloadExtras(List<Quiz> quizzes) async {
    for (Quiz quiz in quizzes) {
      quiz.image = await mediaFileBean.find(quiz.imageId);
    }    
    return quizzes;
  }

  Future<List<Quiz>> findWhereAndPreload(where) async {
    if (where is ExpressionMaker<Quiz>) where = where(this);
    List<Quiz> quizzes = await findWhere(where);
    quizzes = await preloadAll(quizzes);
    return await preloadExtras(quizzes);
  }

  Future<List<Quiz>> getAllAndPreload() async {
    List<Quiz> quizzes = await getAll();
    quizzes = await preloadAll(quizzes);
    return await preloadExtras(quizzes);
  }

  Future<Quiz> findByCode(String code,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.unlockCode.eq(code));
    final Quiz model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }
}
