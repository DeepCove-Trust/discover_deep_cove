import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'quiz.jorm.dart';

class Quiz {
  Quiz();

  @PrimaryKey()
  int id;

  @Column()
  bool _unlocked;

  /// Returns true if the quiz is unlocked. This also takes into consideration
  /// whether there is an unlock code set (quiz is unlocked by default if no
  /// unlock code is set).
  @IgnoreColumn()
  bool get unlocked => unlockCode == null ? true : _unlocked;

  @Column()
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
}

@GenBean()
class QuizBean extends Bean<Quiz> with _QuizBean {
  QuizBean(Adapter adapter)
      : quizQuestionBean = QuizQuestionBean(adapter),
        super(adapter);

  final QuizQuestionBean quizQuestionBean;

  MediaFileBean _mediaFileBean;
  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'quizzes';
}
