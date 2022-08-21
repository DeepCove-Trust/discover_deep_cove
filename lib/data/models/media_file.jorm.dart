// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _MediaFileBean implements Bean<MediaFile> {
  final id = IntField('id');
  final category = StrField('category');
  final name = StrField('name');
  final path = StrField('path');
  final source = StrField('source');
  final showCopyright = BoolField('show_copyright');
  final updatedAt = DateTimeField('updated_at');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        category.name: category,
        name.name: name,
        path.name: path,
        source.name: source,
        showCopyright.name: showCopyright,
        updatedAt.name: updatedAt,
      };
  MediaFile fromMap(Map map) {
    MediaFile model = MediaFile();
    model.id = adapter.parseValue(map['id']);
    model.category = adapter.parseValue(map['category']);
    model.name = adapter.parseValue(map['name']);
    model.path = adapter.parseValue(map['path']);
    model.source = adapter.parseValue(map['source']);
    model.showCopyright = adapter.parseValue(map['show_copyright']);
    model.updatedAt = adapter.parseValue(map['updated_at']);

    return model;
  }

  List<SetColumn> toSetColumns(MediaFile model, {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(category.set(model.category));
      ret.add(name.set(model.name));
      ret.add(path.set(model.path));
      ret.add(source.set(model.source));
      ret.add(showCopyright.set(model.showCopyright));
      ret.add(updatedAt.set(model.updatedAt));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(category.name)) ret.add(category.set(model.category));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(path.name)) ret.add(path.set(model.path));
      if (only.contains(source.name)) ret.add(source.set(model.source));
      if (only.contains(showCopyright.name)) ret.add(showCopyright.set(model.showCopyright));
      if (only.contains(updatedAt.name)) ret.add(updatedAt.set(model.updatedAt));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.category != null) {
        ret.add(category.set(model.category));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.path != null) {
        ret.add(path.set(model.path));
      }
      if (model.source != null) {
        ret.add(source.set(model.source));
      }
      if (model.showCopyright != null) {
        ret.add(showCopyright.set(model.showCopyright));
      }
      if (model.updatedAt != null) {
        ret.add(updatedAt.set(model.updatedAt));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(category.name, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(path.name, isNullable: false);
    st.addStr(source.name, isNullable: true);
    st.addBool(showCopyright.name, isNullable: false);
    st.addDateTime(updatedAt.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(MediaFile model, {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
    final Insert insert = inserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      MediaFile newModel;
      if (model.mainImageEntries != null) {
        newModel ??= await find(model.id);
        model.mainImageEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.mainImageEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
        }
      }
      if (model.listenEntries != null) {
        newModel ??= await find(model.id);
        model.listenEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.listenEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
        }
      }
      if (model.pronunciationEntries != null) {
        newModel ??= await find(model.id);
        model.pronunciationEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.pronunciationEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
        }
      }
      if (model.galleryImageEntries != null) {
        newModel ??= await find(model.id);
        for (final child in model.galleryImageEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
          await factFileEntryImageBean.attach(newModel, child);
        }
      }
      if (model.nuggets != null) {
        newModel ??= await find(model.id);
        model.nuggets.forEach((x) => factFileNuggetBean.associateMediaFile(x, newModel));
        for (final child in model.nuggets) {
          await factFileNuggetBean.insert(child, cascade: cascade);
        }
      }
      if (model.activities != null) {
        newModel ??= await find(model.id);
        model.activities.forEach((x) => activityBean.associateMediaFile(x, newModel));
        for (final child in model.activities) {
          await activityBean.insert(child, cascade: cascade);
        }
      }
      if (model.multiSelectActivities != null) {
        newModel ??= await find(model.id);
        for (final child in model.multiSelectActivities) {
          await activityBean.insert(child, cascade: cascade);
          await activityImageBean.attach(newModel, child);
        }
      }
      if (model.quizzes != null) {
        newModel ??= await find(model.id);
        model.quizzes.forEach((x) => quizBean.associateMediaFile(x, newModel));
        for (final child in model.quizzes) {
          await quizBean.insert(child, cascade: cascade);
        }
      }
      if (model.quizQuestions != null) {
        newModel ??= await find(model.id);
        model.quizQuestions.forEach((x) => quizQuestionBean.associateMediaFile(x, newModel));
        for (final child in model.quizQuestions) {
          await quizQuestionBean.insert(child, cascade: cascade);
        }
      }
      if (model.quizAnswers != null) {
        newModel ??= await find(model.id);
        model.quizAnswers.forEach((x) => quizAnswerBean.associateMediaFile(x, newModel));
        for (final child in model.quizAnswers) {
          await quizAnswerBean.insert(child, cascade: cascade);
        }
      }
      if (model.notices != null) {
        newModel ??= await find(model.id);
        model.notices.forEach((x) => noticeBean.associateMediaFile(x, newModel));
        for (final child in model.notices) {
          await noticeBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<MediaFile> models,
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

  Future<dynamic> upsert(MediaFile model, {bool cascade = false, Set<String> only, bool onlyNonNull = false}) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      MediaFile newModel;
      if (model.mainImageEntries != null) {
        newModel ??= await find(model.id);
        model.mainImageEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.mainImageEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
        }
      }
      if (model.listenEntries != null) {
        newModel ??= await find(model.id);
        model.listenEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.listenEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
        }
      }
      if (model.pronunciationEntries != null) {
        newModel ??= await find(model.id);
        model.pronunciationEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.pronunciationEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
        }
      }
      if (model.galleryImageEntries != null) {
        newModel ??= await find(model.id);
        for (final child in model.galleryImageEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
          await factFileEntryImageBean.attach(newModel, child, upsert: true);
        }
      }
      if (model.nuggets != null) {
        newModel ??= await find(model.id);
        model.nuggets.forEach((x) => factFileNuggetBean.associateMediaFile(x, newModel));
        for (final child in model.nuggets) {
          await factFileNuggetBean.upsert(child, cascade: cascade);
        }
      }
      if (model.activities != null) {
        newModel ??= await find(model.id);
        model.activities.forEach((x) => activityBean.associateMediaFile(x, newModel));
        for (final child in model.activities) {
          await activityBean.upsert(child, cascade: cascade);
        }
      }
      if (model.multiSelectActivities != null) {
        newModel ??= await find(model.id);
        for (final child in model.multiSelectActivities) {
          await activityBean.upsert(child, cascade: cascade);
          await activityImageBean.attach(newModel, child, upsert: true);
        }
      }
      if (model.quizzes != null) {
        newModel ??= await find(model.id);
        model.quizzes.forEach((x) => quizBean.associateMediaFile(x, newModel));
        for (final child in model.quizzes) {
          await quizBean.upsert(child, cascade: cascade);
        }
      }
      if (model.quizQuestions != null) {
        newModel ??= await find(model.id);
        model.quizQuestions.forEach((x) => quizQuestionBean.associateMediaFile(x, newModel));
        for (final child in model.quizQuestions) {
          await quizQuestionBean.upsert(child, cascade: cascade);
        }
      }
      if (model.quizAnswers != null) {
        newModel ??= await find(model.id);
        model.quizAnswers.forEach((x) => quizAnswerBean.associateMediaFile(x, newModel));
        for (final child in model.quizAnswers) {
          await quizAnswerBean.upsert(child, cascade: cascade);
        }
      }
      if (model.notices != null) {
        newModel ??= await find(model.id);
        model.notices.forEach((x) => noticeBean.associateMediaFile(x, newModel));
        for (final child in model.notices) {
          await noticeBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<MediaFile> models,
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

  Future<int> update(MediaFile model,
      {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false}) async {
    final Update update =
        updater.where(id.eq(model.id)).setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      MediaFile newModel;
      if (model.mainImageEntries != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.mainImageEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        }
        for (final child in model.mainImageEntries) {
          await factFileEntryBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.listenEntries != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.listenEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        }
        for (final child in model.listenEntries) {
          await factFileEntryBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.pronunciationEntries != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.pronunciationEntries.forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        }
        for (final child in model.pronunciationEntries) {
          await factFileEntryBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.galleryImageEntries != null) {
        for (final child in model.galleryImageEntries) {
          await factFileEntryBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.nuggets != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.nuggets.forEach((x) => factFileNuggetBean.associateMediaFile(x, newModel));
        }
        for (final child in model.nuggets) {
          await factFileNuggetBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.activities != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.activities.forEach((x) => activityBean.associateMediaFile(x, newModel));
        }
        for (final child in model.activities) {
          await activityBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.multiSelectActivities != null) {
        for (final child in model.multiSelectActivities) {
          await activityBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.quizzes != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.quizzes.forEach((x) => quizBean.associateMediaFile(x, newModel));
        }
        for (final child in model.quizzes) {
          await quizBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.quizQuestions != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.quizQuestions.forEach((x) => quizQuestionBean.associateMediaFile(x, newModel));
        }
        for (final child in model.quizQuestions) {
          await quizQuestionBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.quizAnswers != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.quizAnswers.forEach((x) => quizAnswerBean.associateMediaFile(x, newModel));
        }
        for (final child in model.quizAnswers) {
          await quizAnswerBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.notices != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.notices.forEach((x) => noticeBean.associateMediaFile(x, newModel));
        }
        for (final child in model.notices) {
          await noticeBean.update(child, cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<MediaFile> models,
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

  Future<MediaFile> find(int id, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final MediaFile model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final MediaFile newModel = await find(id);
      if (newModel != null) {
        await factFileEntryBean.removeByMediaFile(newModel.id, newModel.id, newModel.id);
        await factFileEntryBean.removeByMediaFile(newModel.id, newModel.id, newModel.id);
        await factFileEntryBean.removeByMediaFile(newModel.id, newModel.id, newModel.id);
        await factFileEntryImageBean.detachMediaFile(newModel);
        await factFileNuggetBean.removeByMediaFile(newModel.id);
        await activityBean.removeByMediaFile(newModel.id, newModel.id);
        await activityImageBean.detachMediaFile(newModel);
        await quizBean.removeByMediaFile(newModel.id);
        await quizQuestionBean.removeByMediaFile(newModel.id, newModel.id);
        await quizAnswerBean.removeByMediaFile(newModel.id);
        await noticeBean.removeByMediaFile(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<MediaFile> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<MediaFile> preload(MediaFile model, {bool cascade = false}) async {
    model.mainImageEntries =
        await factFileEntryBean.findByMediaFile(model.id, model.id, model.id, preload: cascade, cascade: cascade);
    model.listenEntries =
        await factFileEntryBean.findByMediaFile(model.id, model.id, model.id, preload: cascade, cascade: cascade);
    model.pronunciationEntries =
        await factFileEntryBean.findByMediaFile(model.id, model.id, model.id, preload: cascade, cascade: cascade);
    model.galleryImageEntries = await factFileEntryImageBean.fetchByMediaFile(model);
    model.nuggets = await factFileNuggetBean.findByMediaFile(model.id, preload: cascade, cascade: cascade);
    model.activities = await activityBean.findByMediaFile(model.id, model.id, preload: cascade, cascade: cascade);
    model.multiSelectActivities = await activityImageBean.fetchByMediaFile(model);
    model.quizzes = await quizBean.findByMediaFile(model.id, preload: cascade, cascade: cascade);
    model.quizQuestions =
        await quizQuestionBean.findByMediaFile(model.id, model.id, preload: cascade, cascade: cascade);
    model.quizAnswers = await quizAnswerBean.findByMediaFile(model.id, preload: cascade, cascade: cascade);
    model.notices = await noticeBean.findByMediaFile(model.id, preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<MediaFile>> preloadAll(List<MediaFile> models, {bool cascade = false}) async {
    models.forEach((MediaFile model) => model.mainImageEntries ??= []);
    await OneToXHelper.preloadAll<MediaFile, FactFileEntry>(
        models,
        (MediaFile model) => [model.id, model.id, model.id],
        factFileEntryBean.findByMediaFileList,
        (FactFileEntry model) => [model.mainImageId, model.pronounceAudioId, model.listenAudioId],
        (MediaFile model, FactFileEntry child) =>
            model.mainImageEntries = List.from(model.mainImageEntries)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.listenEntries ??= []);
    await OneToXHelper.preloadAll<MediaFile, FactFileEntry>(
        models,
        (MediaFile model) => [model.id, model.id, model.id],
        factFileEntryBean.findByMediaFileList,
        (FactFileEntry model) => [model.mainImageId, model.pronounceAudioId, model.listenAudioId],
        (MediaFile model, FactFileEntry child) => model.listenEntries = List.from(model.listenEntries)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.pronunciationEntries ??= []);
    await OneToXHelper.preloadAll<MediaFile, FactFileEntry>(
        models,
        (MediaFile model) => [model.id, model.id, model.id],
        factFileEntryBean.findByMediaFileList,
        (FactFileEntry model) => [model.mainImageId, model.pronounceAudioId, model.listenAudioId],
        (MediaFile model, FactFileEntry child) =>
            model.pronunciationEntries = List.from(model.pronunciationEntries)..add(child),
        cascade: cascade);
    for (MediaFile model in models) {
      var temp = await factFileEntryImageBean.fetchByMediaFile(model);
      if (model.galleryImageEntries == null) {
        model.galleryImageEntries = temp;
      } else {
        model.galleryImageEntries.clear();
        model.galleryImageEntries.addAll(temp);
      }
    }
    models.forEach((MediaFile model) => model.nuggets ??= []);
    await OneToXHelper.preloadAll<MediaFile, FactFileNugget>(
        models,
        (MediaFile model) => [model.id],
        factFileNuggetBean.findByMediaFileList,
        (FactFileNugget model) => [model.imageId],
        (MediaFile model, FactFileNugget child) => model.nuggets = List.from(model.nuggets)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.activities ??= []);
    await OneToXHelper.preloadAll<MediaFile, Activity>(
        models,
        (MediaFile model) => [model.id, model.id],
        activityBean.findByMediaFileList,
        (Activity model) => [model.imageId, model.selectedPictureId],
        (MediaFile model, Activity child) => model.activities = List.from(model.activities)..add(child),
        cascade: cascade);
    for (MediaFile model in models) {
      var temp = await activityImageBean.fetchByMediaFile(model);
      if (model.multiSelectActivities == null) {
        model.multiSelectActivities = temp;
      } else {
        model.multiSelectActivities.clear();
        model.multiSelectActivities.addAll(temp);
      }
    }
    models.forEach((MediaFile model) => model.quizzes ??= []);
    await OneToXHelper.preloadAll<MediaFile, Quiz>(
        models,
        (MediaFile model) => [model.id],
        quizBean.findByMediaFileList,
        (Quiz model) => [model.imageId],
        (MediaFile model, Quiz child) => model.quizzes = List.from(model.quizzes)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.quizQuestions ??= []);
    await OneToXHelper.preloadAll<MediaFile, QuizQuestion>(
        models,
        (MediaFile model) => [model.id, model.id],
        quizQuestionBean.findByMediaFileList,
        (QuizQuestion model) => [model.imageId, model.audioId],
        (MediaFile model, QuizQuestion child) => model.quizQuestions = List.from(model.quizQuestions)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.quizAnswers ??= []);
    await OneToXHelper.preloadAll<MediaFile, QuizAnswer>(
        models,
        (MediaFile model) => [model.id],
        quizAnswerBean.findByMediaFileList,
        (QuizAnswer model) => [model.imageId],
        (MediaFile model, QuizAnswer child) => model.quizAnswers = List.from(model.quizAnswers)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.notices ??= []);
    await OneToXHelper.preloadAll<MediaFile, Notice>(
        models,
        (MediaFile model) => [model.id],
        noticeBean.findByMediaFileList,
        (Notice model) => [model.imageId],
        (MediaFile model, Notice child) => model.notices = List.from(model.notices)..add(child),
        cascade: cascade);
    return models;
  }

  FactFileEntryBean get factFileEntryBean;
  FactFileEntryImageBean get factFileEntryImageBean;
  FactFileNuggetBean get factFileNuggetBean;
  ActivityBean get activityBean;
  ActivityImageBean get activityImageBean;
  QuizBean get quizBean;
  QuizQuestionBean get quizQuestionBean;
  QuizAnswerBean get quizAnswerBean;
  NoticeBean get noticeBean;
}
