// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _QuizBean implements Bean<Quiz> {
  final id = IntField('id');
  final lastModified = DateTimeField('last_modified');
  final unlocked = BoolField('unlocked');
  final unlockCode = StrField('unlock_code');
  final title = StrField('title');
  final attempts = IntField('attempts');
  final highScore = IntField('high_score');
  final imageId = IntField('image_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        lastModified.name: lastModified,
        unlocked.name: unlocked,
        unlockCode.name: unlockCode,
        title.name: title,
        attempts.name: attempts,
        highScore.name: highScore,
        imageId.name: imageId,
      };
  Quiz fromMap(Map map) {
    Quiz model = Quiz();
    model.id = adapter.parseValue(map['id']);
    model.lastModified = adapter.parseValue(map['last_modified']);
    model.unlocked = adapter.parseValue(map['unlocked']);
    model.unlockCode = adapter.parseValue(map['unlock_code']);
    model.title = adapter.parseValue(map['title']);
    model.attempts = adapter.parseValue(map['attempts']);
    model.highScore = adapter.parseValue(map['high_score']);
    model.imageId = adapter.parseValue(map['image_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Quiz model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(lastModified.set(model.lastModified));
      ret.add(unlocked.set(model.unlocked));
      ret.add(unlockCode.set(model.unlockCode));
      ret.add(title.set(model.title));
      ret.add(attempts.set(model.attempts));
      ret.add(highScore.set(model.highScore));
      ret.add(imageId.set(model.imageId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(lastModified.name))
        ret.add(lastModified.set(model.lastModified));
      if (only.contains(unlocked.name)) ret.add(unlocked.set(model.unlocked));
      if (only.contains(unlockCode.name))
        ret.add(unlockCode.set(model.unlockCode));
      if (only.contains(title.name)) ret.add(title.set(model.title));
      if (only.contains(attempts.name)) ret.add(attempts.set(model.attempts));
      if (only.contains(highScore.name))
        ret.add(highScore.set(model.highScore));
      if (only.contains(imageId.name)) ret.add(imageId.set(model.imageId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.lastModified != null) {
        ret.add(lastModified.set(model.lastModified));
      }
      if (model.unlocked != null) {
        ret.add(unlocked.set(model.unlocked));
      }
      if (model.unlockCode != null) {
        ret.add(unlockCode.set(model.unlockCode));
      }
      if (model.title != null) {
        ret.add(title.set(model.title));
      }
      if (model.attempts != null) {
        ret.add(attempts.set(model.attempts));
      }
      if (model.highScore != null) {
        ret.add(highScore.set(model.highScore));
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
    st.addDateTime(lastModified.name, isNullable: false);
    st.addBool(unlocked.name, isNullable: true);
    st.addStr(unlockCode.name, isNullable: true);
    st.addStr(title.name, isNullable: false);
    st.addInt(attempts.name, isNullable: true);
    st.addInt(highScore.name, isNullable: true);
    st.addInt(imageId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Quiz model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Quiz newModel;
      if (model.questions != null) {
        newModel ??= await find(model.id);
        model.questions
            .forEach((x) => quizQuestionBean.associateQuiz(x, newModel));
        for (final child in model.questions) {
          await quizQuestionBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Quiz> models,
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

  Future<dynamic> upsert(Quiz model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Quiz newModel;
      if (model.questions != null) {
        newModel ??= await find(model.id);
        model.questions
            .forEach((x) => quizQuestionBean.associateQuiz(x, newModel));
        for (final child in model.questions) {
          await quizQuestionBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Quiz> models,
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

  Future<int> update(Quiz model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Quiz newModel;
      if (model.questions != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.questions
              .forEach((x) => quizQuestionBean.associateQuiz(x, newModel));
        }
        for (final child in model.questions) {
          await quizQuestionBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Quiz> models,
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

  Future<Quiz> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Quiz model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Quiz newModel = await find(id);
      if (newModel != null) {
        await quizQuestionBean.removeByQuiz(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Quiz> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Quiz>> findByMediaFile(int imageId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.imageId.eq(imageId));
    final List<Quiz> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<Quiz>> findByMediaFileList(List<MediaFile> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (MediaFile model in models) {
      find.or(this.imageId.eq(model.id));
    }
    final List<Quiz> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByMediaFile(int imageId) async {
    final Remove rm = remover.where(this.imageId.eq(imageId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(Quiz child, MediaFile parent) {
    child.imageId = parent.id;
  }

  Future<Quiz> preload(Quiz model, {bool cascade = false}) async {
    model.questions = await quizQuestionBean.findByQuiz(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<Quiz>> preloadAll(List<Quiz> models,
      {bool cascade = false}) async {
    models.forEach((Quiz model) => model.questions ??= []);
    await OneToXHelper.preloadAll<Quiz, QuizQuestion>(
        models,
        (Quiz model) => [model.id],
        quizQuestionBean.findByQuizList,
        (QuizQuestion model) => [model.quizId],
        (Quiz model, QuizQuestion child) =>
            model.questions = List.from(model.questions)..add(child),
        cascade: cascade);
    return models;
  }

  QuizQuestionBean get quizQuestionBean;
  MediaFileBean get mediaFileBean;
}
