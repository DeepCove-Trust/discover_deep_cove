// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _QuizAnswerBean implements Bean<QuizAnswer> {
  final id = IntField('id');
  final quizQuestionId = IntField('quiz_question_id');
  final text = StrField('text');
  final imageId = IntField('image_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        quizQuestionId.name: quizQuestionId,
        text.name: text,
        imageId.name: imageId,
      };
  QuizAnswer fromMap(Map map) {
    QuizAnswer model = QuizAnswer();
    model.id = adapter.parseValue(map['id']);
    model.quizQuestionId = adapter.parseValue(map['quiz_question_id']);
    model.text = adapter.parseValue(map['text']);
    model.imageId = adapter.parseValue(map['image_id']);

    return model;
  }

  List<SetColumn> toSetColumns(QuizAnswer model, {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(quizQuestionId.set(model.quizQuestionId));
      ret.add(text.set(model.text));
      ret.add(imageId.set(model.imageId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(quizQuestionId.name)) ret.add(quizQuestionId.set(model.quizQuestionId));
      if (only.contains(text.name)) ret.add(text.set(model.text));
      if (only.contains(imageId.name)) ret.add(imageId.set(model.imageId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.quizQuestionId != null) {
        ret.add(quizQuestionId.set(model.quizQuestionId));
      }
      if (model.text != null) {
        ret.add(text.set(model.text));
      }
      if (model.imageId != null) {
        ret.add(imageId.set(model.imageId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addInt(quizQuestionId.name, foreignTable: quizQuestionBean.tableName, foreignCol: 'id', isNullable: false);
    st.addStr(text.name, isNullable: true);
    st.addInt(imageId.name, foreignTable: mediaFileBean.tableName, foreignCol: 'id', isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(QuizAnswer model, {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
    final Insert insert = inserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      QuizAnswer newModel;
      if (model.correctForQuestion != null) {
        newModel ??= await find(model.id);
        quizQuestionBean.associateQuizAnswer(model.correctForQuestion, newModel);
        await quizQuestionBean.insert(model.correctForQuestion, cascade: cascade);
      }
    }
    return retId;
  }

  Future<void> insertMany(List<QuizAnswer> models,
      {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data =
          models.map((model) => toSetColumns(model, only: only, onlyNonNull: onlyNonNull)).toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(QuizAnswer model, {bool cascade = false, Set<String> only, bool onlyNonNull = false}) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      QuizAnswer newModel;
      if (model.correctForQuestion != null) {
        newModel ??= await find(model.id);
        quizQuestionBean.associateQuizAnswer(model.correctForQuestion, newModel);
        await quizQuestionBean.upsert(model.correctForQuestion, cascade: cascade);
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<QuizAnswer> models,
      {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
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
        data.add(toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(QuizAnswer model,
      {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false}) async {
    final Update update =
        updater.where(id.eq(model.id)).setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      QuizAnswer newModel;
      if (model.correctForQuestion != null) {
        if (associate) {
          newModel ??= await find(model.id);
          quizQuestionBean.associateQuizAnswer(model.correctForQuestion, newModel);
        }
        await quizQuestionBean.update(model.correctForQuestion, cascade: cascade, associate: associate);
      }
    }
    return ret;
  }

  Future<void> updateMany(List<QuizAnswer> models,
      {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
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
        data.add(toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<QuizAnswer> find(int id, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final QuizAnswer model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final QuizAnswer newModel = await find(id);
      if (newModel != null) {
        await quizQuestionBean.removeByQuizAnswer(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<QuizAnswer> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<QuizAnswer>> findByQuizQuestion(int quizQuestionId, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.quizQuestionId.eq(quizQuestionId));
    final List<QuizAnswer> models = await findMany(find);
    if (preload) {
      await preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<QuizAnswer>> findByQuizQuestionList(List<QuizQuestion> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (QuizQuestion model in models) {
      find.or(quizQuestionId.eq(model.id));
    }
    final List<QuizAnswer> retModels = await findMany(find);
    if (preload) {
      await preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByQuizQuestion(int quizQuestionId) async {
    final Remove rm = remover.where(this.quizQuestionId.eq(quizQuestionId));
    return await adapter.remove(rm);
  }

  void associateQuizQuestion(QuizAnswer child, QuizQuestion parent) {
    child.quizQuestionId = parent.id;
  }

  Future<List<QuizAnswer>> findByMediaFile(int imageId, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.imageId.eq(imageId));
    final List<QuizAnswer> models = await findMany(find);
    if (preload) {
      await preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<QuizAnswer>> findByMediaFileList(List<MediaFile> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (MediaFile model in models) {
      find.or(imageId.eq(model.id));
    }
    final List<QuizAnswer> retModels = await findMany(find);
    if (preload) {
      await preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByMediaFile(int imageId) async {
    final Remove rm = remover.where(this.imageId.eq(imageId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(QuizAnswer child, MediaFile parent) {
    child.imageId = parent.id;
  }

  Future<QuizAnswer> preload(QuizAnswer model, {bool cascade = false}) async {
    model.correctForQuestion = await quizQuestionBean.findByQuizAnswer(model.id, preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<QuizAnswer>> preloadAll(List<QuizAnswer> models, {bool cascade = false}) async {
    await OneToXHelper.preloadAll<QuizAnswer, QuizQuestion>(
        models,
        (QuizAnswer model) => [model.id],
        quizQuestionBean.findByQuizAnswerList,
        (QuizQuestion model) => [model.correctAnswerId],
        (QuizAnswer model, QuizQuestion child) => model.correctForQuestion = child,
        cascade: cascade);
    return models;
  }

  QuizQuestionBean get quizQuestionBean;
  MediaFileBean get mediaFileBean;
}
