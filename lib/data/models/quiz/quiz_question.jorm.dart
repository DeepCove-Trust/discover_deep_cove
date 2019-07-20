// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _QuizQuestionBean implements Bean<QuizQuestion> {
  final id = IntField('id');
  final quizId = IntField('quiz_id');
  final trueFalseAnswer = BoolField('true_false_answer');
  final text = StrField('text');
  final imageId = IntField('image_id');
  final audioId = IntField('audio_id');
  final correctAnswerId = IntField('correct_answer_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        quizId.name: quizId,
        trueFalseAnswer.name: trueFalseAnswer,
        text.name: text,
        imageId.name: imageId,
        audioId.name: audioId,
        correctAnswerId.name: correctAnswerId,
      };
  QuizQuestion fromMap(Map map) {
    QuizQuestion model = QuizQuestion();
    model.id = adapter.parseValue(map['id']);
    model.quizId = adapter.parseValue(map['quiz_id']);
    model.trueFalseAnswer = adapter.parseValue(map['true_false_answer']);
    model.text = adapter.parseValue(map['text']);
    model.imageId = adapter.parseValue(map['image_id']);
    model.audioId = adapter.parseValue(map['audio_id']);
    model.correctAnswerId = adapter.parseValue(map['correct_answer_id']);

    return model;
  }

  List<SetColumn> toSetColumns(QuizQuestion model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(quizId.set(model.quizId));
      ret.add(trueFalseAnswer.set(model.trueFalseAnswer));
      ret.add(text.set(model.text));
      ret.add(imageId.set(model.imageId));
      ret.add(audioId.set(model.audioId));
      ret.add(correctAnswerId.set(model.correctAnswerId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(quizId.name)) ret.add(quizId.set(model.quizId));
      if (only.contains(trueFalseAnswer.name))
        ret.add(trueFalseAnswer.set(model.trueFalseAnswer));
      if (only.contains(text.name)) ret.add(text.set(model.text));
      if (only.contains(imageId.name)) ret.add(imageId.set(model.imageId));
      if (only.contains(audioId.name)) ret.add(audioId.set(model.audioId));
      if (only.contains(correctAnswerId.name))
        ret.add(correctAnswerId.set(model.correctAnswerId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.quizId != null) {
        ret.add(quizId.set(model.quizId));
      }
      if (model.trueFalseAnswer != null) {
        ret.add(trueFalseAnswer.set(model.trueFalseAnswer));
      }
      if (model.text != null) {
        ret.add(text.set(model.text));
      }
      if (model.imageId != null) {
        ret.add(imageId.set(model.imageId));
      }
      if (model.audioId != null) {
        ret.add(audioId.set(model.audioId));
      }
      if (model.correctAnswerId != null) {
        ret.add(correctAnswerId.set(model.correctAnswerId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addInt(quizId.name,
        foreignTable: quizBean.tableName, foreignCol: 'id', isNullable: false);
    st.addBool(trueFalseAnswer.name, isNullable: true);
    st.addStr(text.name, isNullable: false);
    st.addInt(imageId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: true);
    st.addInt(audioId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: true);
    st.addInt(correctAnswerId.name,
        foreignTable: quizAnswerBean.tableName,
        foreignCol: 'id',
        isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(QuizQuestion model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      QuizQuestion newModel;
      if (model.answers != null) {
        newModel ??= await find(model.id);
        model.answers
            .forEach((x) => quizAnswerBean.associateQuizQuestion(x, newModel));
        for (final child in model.answers) {
          await quizAnswerBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<QuizQuestion> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(QuizQuestion model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      QuizQuestion newModel;
      if (model.answers != null) {
        newModel ??= await find(model.id);
        model.answers
            .forEach((x) => quizAnswerBean.associateQuizQuestion(x, newModel));
        for (final child in model.answers) {
          await quizAnswerBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<QuizQuestion> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(QuizQuestion model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      QuizQuestion newModel;
      if (model.answers != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.answers.forEach(
              (x) => quizAnswerBean.associateQuizQuestion(x, newModel));
        }
        for (final child in model.answers) {
          await quizAnswerBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<QuizQuestion> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<QuizQuestion> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final QuizQuestion model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final QuizQuestion newModel = await find(id);
      if (newModel != null) {
        await quizAnswerBean.removeByQuizQuestion(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<QuizQuestion> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<QuizQuestion>> findByQuiz(int quizId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.quizId.eq(quizId));
    final List<QuizQuestion> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<QuizQuestion>> findByQuizList(List<Quiz> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Quiz model in models) {
      find.or(this.quizId.eq(model.id));
    }
    final List<QuizQuestion> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByQuiz(int quizId) async {
    final Remove rm = remover.where(this.quizId.eq(quizId));
    return await adapter.remove(rm);
  }

  void associateQuiz(QuizQuestion child, Quiz parent) {
    child.quizId = parent.id;
  }

  Future<List<QuizQuestion>> findByMediaFile(int imageId, int audioId,
      {bool preload = false, bool cascade = false}) async {
    final Find find =
        finder.where(this.imageId.eq(imageId)).where(this.audioId.eq(audioId));
    final List<QuizQuestion> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<QuizQuestion>> findByMediaFileList(List<MediaFile> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (MediaFile model in models) {
      find.or(this.imageId.eq(model.id) & this.audioId.eq(model.id));
    }
    final List<QuizQuestion> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByMediaFile(int imageId, int audioId) async {
    final Remove rm =
        remover.where(this.imageId.eq(imageId)).where(this.audioId.eq(audioId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(QuizQuestion child, MediaFile parent) {
    child.imageId = parent.id;
    child.audioId = parent.id;
  }

  Future<QuizQuestion> findByQuizAnswer(int correctAnswerId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.correctAnswerId.eq(correctAnswerId));
    final QuizQuestion model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<List<QuizQuestion>> findByQuizAnswerList(List<QuizAnswer> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (QuizAnswer model in models) {
      find.or(this.correctAnswerId.eq(model.id));
    }
    final List<QuizQuestion> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByQuizAnswer(int correctAnswerId) async {
    final Remove rm = remover.where(this.correctAnswerId.eq(correctAnswerId));
    return await adapter.remove(rm);
  }

  void associateQuizAnswer(QuizQuestion child, QuizAnswer parent) {
    child.correctAnswerId = parent.id;
  }

  Future<QuizQuestion> preload(QuizQuestion model,
      {bool cascade = false}) async {
    model.answers = await quizAnswerBean.findByQuizQuestion(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<QuizQuestion>> preloadAll(List<QuizQuestion> models,
      {bool cascade = false}) async {
    models.forEach((QuizQuestion model) => model.answers ??= []);
    await OneToXHelper.preloadAll<QuizQuestion, QuizAnswer>(
        models,
        (QuizQuestion model) => [model.id],
        quizAnswerBean.findByQuizQuestionList,
        (QuizAnswer model) => [model.questionId],
        (QuizQuestion model, QuizAnswer child) =>
            model.answers = List.from(model.answers)..add(child),
        cascade: cascade);
    return models;
  }

  QuizAnswerBean get quizAnswerBean;
  QuizBean get quizBean;
  MediaFileBean get mediaFileBean;
}
