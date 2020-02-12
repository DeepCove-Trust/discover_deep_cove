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
  DateTime updatedAt;

  @Column(name: 'unlocked', isNullable: true)
  bool _unlocked;

  /// Returns true if the quiz is unlocked. This also takes into consideration
  /// whether there is an unlock code set (quiz is unlocked by default if no
  /// unlock code is set).
  @IgnoreColumn()
  bool get unlocked => unlockCode == null ? true : (_unlocked ?? false);
  void setUnlocked(val) => _unlocked = val;

  @Column(isNullable: true)
  String unlockCode;

  @Column(name: 'shuffle')
  int _shuffle;

  @IgnoreColumn()
  bool get shuffle => _shuffle == 1;

  @Column()
  String title;

  @Column(name: 'attempts', isNullable: true)
  int _attempts;

  @IgnoreColumn()
  int get attempts => _attempts ?? 0;
  void setAttempts(val) => _attempts = val;

  @Column(name: 'high_score', isNullable: true)
  int _highScore;

  @IgnoreColumn()
  int get highScore => _highScore ?? 0;
  void setHighScore(val) => _highScore = val;


  @HasMany(QuizQuestionBean)
  List<QuizQuestion> questions;

  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  @IgnoreColumn()
  MediaFile image;
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

  Future<List<Quiz>> preloadExtrasForAll(List<Quiz> quizzes) async {
    for (Quiz quiz in quizzes) {
      await preloadExtras(quiz);
    }
    return quizzes;
  }

  Future<Quiz> preloadExtras(Quiz quiz)async{
    quiz.image = await mediaFileBean.find(quiz.imageId);
    return quiz;
  }

  Future<List<Quiz>> findWhereAndPreload(where) async {
    if (where is ExpressionMaker<Quiz>) where = where(this);
    List<Quiz> quizzes = await findWhere(where);
    quizzes = await preloadAll(quizzes);
    return await preloadExtrasForAll(quizzes);
  }

  Future<List<Quiz>> getAllAndPreload() async {
    List<Quiz> quizzes = await getAll();
    quizzes = await preloadAll(quizzes);
    return await preloadExtrasForAll(quizzes);
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

  /// Resets the attempts and highscore for the given ID
  Future<void> clearProgress(int id) async {
    Quiz quiz = await find(id);
    quiz.setAttempts(0);
    quiz.setHighScore(0);
    quiz._unlocked = false;
    await update(quiz);
  }
}
