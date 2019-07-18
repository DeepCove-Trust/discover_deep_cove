import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'quiz_question.jorm.dart';

class QuizQuestion {
  QuizQuestion();

  @PrimaryKey()
  int id;

  @BelongsTo(QuizBean)
  int quizId;

  @Column(isNullable: true)
  bool trueFalseAnswer;

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
  MediaFile image; // TODO: Preload these fields

  @IgnoreColumn()
  MediaFile audio;

  @IgnoreColumn()
  QuizAnswer correctAnswer;
}

@GenBean()
class QuizQuestionBean extends Bean<QuizQuestion> with _QuizQuestionBean {
  QuizQuestionBean(Adapter adapter)
      : quizAnswerBean = QuizAnswerBean(adapter),
        super(adapter);

  final QuizAnswerBean quizAnswerBean;

  MediaFileBean _mediaFileBean;
  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  QuizBean _quizBean;
  QuizBean get quizBean => _quizBean ?? QuizBean(adapter);

  final String tableName = 'quiz_questions';
}
