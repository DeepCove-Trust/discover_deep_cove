// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_file_entry.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _FactFileEntryBean implements Bean<FactFileEntry> {
  final id = IntField('id');
  final categoryId = IntField('category_id');
  final primaryName = StrField('primary_name');
  final altName = StrField('alt_name');
  final cardText = StrField('card_text');
  final bodyText = StrField('body_text');
  final mainImageId = IntField('main_image_id');
  final pronounceAudioId = IntField('pronounce_audio_id');
  final listenAudioId = IntField('listen_audio_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        categoryId.name: categoryId,
        primaryName.name: primaryName,
        altName.name: altName,
        cardText.name: cardText,
        bodyText.name: bodyText,
        mainImageId.name: mainImageId,
        pronounceAudioId.name: pronounceAudioId,
        listenAudioId.name: listenAudioId,
      };
  FactFileEntry fromMap(Map map) {
    FactFileEntry model = FactFileEntry();
    model.id = adapter.parseValue(map['id']);
    model.categoryId = adapter.parseValue(map['category_id']);
    model.primaryName = adapter.parseValue(map['primary_name']);
    model.altName = adapter.parseValue(map['alt_name']);
    model.cardText = adapter.parseValue(map['card_text']);
    model.bodyText = adapter.parseValue(map['body_text']);
    model.mainImageId = adapter.parseValue(map['main_image_id']);
    model.pronounceAudioId = adapter.parseValue(map['pronounce_audio_id']);
    model.listenAudioId = adapter.parseValue(map['listen_audio_id']);

    return model;
  }

  List<SetColumn> toSetColumns(FactFileEntry model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(categoryId.set(model.categoryId));
      ret.add(primaryName.set(model.primaryName));
      ret.add(altName.set(model.altName));
      ret.add(cardText.set(model.cardText));
      ret.add(bodyText.set(model.bodyText));
      ret.add(mainImageId.set(model.mainImageId));
      ret.add(pronounceAudioId.set(model.pronounceAudioId));
      ret.add(listenAudioId.set(model.listenAudioId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(categoryId.name))
        ret.add(categoryId.set(model.categoryId));
      if (only.contains(primaryName.name))
        ret.add(primaryName.set(model.primaryName));
      if (only.contains(altName.name)) ret.add(altName.set(model.altName));
      if (only.contains(cardText.name)) ret.add(cardText.set(model.cardText));
      if (only.contains(bodyText.name)) ret.add(bodyText.set(model.bodyText));
      if (only.contains(mainImageId.name))
        ret.add(mainImageId.set(model.mainImageId));
      if (only.contains(pronounceAudioId.name))
        ret.add(pronounceAudioId.set(model.pronounceAudioId));
      if (only.contains(listenAudioId.name))
        ret.add(listenAudioId.set(model.listenAudioId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.categoryId != null) {
        ret.add(categoryId.set(model.categoryId));
      }
      if (model.primaryName != null) {
        ret.add(primaryName.set(model.primaryName));
      }
      if (model.altName != null) {
        ret.add(altName.set(model.altName));
      }
      if (model.cardText != null) {
        ret.add(cardText.set(model.cardText));
      }
      if (model.bodyText != null) {
        ret.add(bodyText.set(model.bodyText));
      }
      if (model.mainImageId != null) {
        ret.add(mainImageId.set(model.mainImageId));
      }
      if (model.pronounceAudioId != null) {
        ret.add(pronounceAudioId.set(model.pronounceAudioId));
      }
      if (model.listenAudioId != null) {
        ret.add(listenAudioId.set(model.listenAudioId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addInt(categoryId.name,
        foreignTable: factFileCategoryBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addStr(primaryName.name, isNullable: false);
    st.addStr(altName.name, isNullable: false);
    st.addStr(cardText.name, isNullable: false);
    st.addStr(bodyText.name, isNullable: false);
    st.addInt(mainImageId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addInt(pronounceAudioId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addInt(listenAudioId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(FactFileEntry model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      FactFileEntry newModel;
      if (model.galleryImages != null) {
        newModel ??= await find(model.id);
        for (final child in model.galleryImages) {
          await mediaFileBean.insert(child, cascade: cascade);
          await factFileEntryImageBean.attach(child, newModel);
        }
      }
      if (model.nuggets != null) {
        newModel ??= await find(model.id);
        model.nuggets.forEach(
            (x) => factFileNuggetBean.associateFactFileEntry(x, newModel));
        for (final child in model.nuggets) {
          await factFileNuggetBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<FactFileEntry> models,
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

  Future<dynamic> upsert(FactFileEntry model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      FactFileEntry newModel;
      if (model.galleryImages != null) {
        newModel ??= await find(model.id);
        for (final child in model.galleryImages) {
          await mediaFileBean.upsert(child, cascade: cascade);
          await factFileEntryImageBean.attach(child, newModel, upsert: true);
        }
      }
      if (model.nuggets != null) {
        newModel ??= await find(model.id);
        model.nuggets.forEach(
            (x) => factFileNuggetBean.associateFactFileEntry(x, newModel));
        for (final child in model.nuggets) {
          await factFileNuggetBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<FactFileEntry> models,
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

  Future<int> update(FactFileEntry model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      FactFileEntry newModel;
      if (model.galleryImages != null) {
        for (final child in model.galleryImages) {
          await mediaFileBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.nuggets != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.nuggets.forEach(
              (x) => factFileNuggetBean.associateFactFileEntry(x, newModel));
        }
        for (final child in model.nuggets) {
          await factFileNuggetBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<FactFileEntry> models,
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

  Future<FactFileEntry> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final FactFileEntry model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final FactFileEntry newModel = await find(id);
      if (newModel != null) {
        await factFileEntryImageBean.detachFactFileEntry(newModel);
        await factFileNuggetBean.removeByFactFileEntry(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<FactFileEntry> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<FactFileEntry>> findByFactFileCategory(int categoryId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.categoryId.eq(categoryId));
    final List<FactFileEntry> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<FactFileEntry>> findByFactFileCategoryList(
      List<FactFileCategory> models,
      {bool preload = false,
      bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (FactFileCategory model in models) {
      find.or(this.categoryId.eq(model.id));
    }
    final List<FactFileEntry> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByFactFileCategory(int categoryId) async {
    final Remove rm = remover.where(this.categoryId.eq(categoryId));
    return await adapter.remove(rm);
  }

  void associateFactFileCategory(FactFileEntry child, FactFileCategory parent) {
    child.categoryId = parent.id;
  }

  Future<List<FactFileEntry>> findByMediaFile(
      int mainImageId, int pronounceAudioId, int listenAudioId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder
        .where(this.mainImageId.eq(mainImageId))
        .where(this.pronounceAudioId.eq(pronounceAudioId))
        .where(this.listenAudioId.eq(listenAudioId));
    final List<FactFileEntry> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<FactFileEntry>> findByMediaFileList(List<MediaFile> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (MediaFile model in models) {
      find.or(this.mainImageId.eq(model.id) &
          this.pronounceAudioId.eq(model.id) &
          this.listenAudioId.eq(model.id));
    }
    final List<FactFileEntry> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByMediaFile(
      int mainImageId, int pronounceAudioId, int listenAudioId) async {
    final Remove rm = remover
        .where(this.mainImageId.eq(mainImageId))
        .where(this.pronounceAudioId.eq(pronounceAudioId))
        .where(this.listenAudioId.eq(listenAudioId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(FactFileEntry child, MediaFile parent) {
    child.mainImageId = parent.id;
    child.pronounceAudioId = parent.id;
    child.listenAudioId = parent.id;
  }

  Future<FactFileEntry> preload(FactFileEntry model,
      {bool cascade = false}) async {
    model.galleryImages =
        await factFileEntryImageBean.fetchByFactFileEntry(model);
    model.nuggets = await factFileNuggetBean.findByFactFileEntry(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<FactFileEntry>> preloadAll(List<FactFileEntry> models,
      {bool cascade = false}) async {
    for (FactFileEntry model in models) {
      var temp = await factFileEntryImageBean.fetchByFactFileEntry(model);
      if (model.galleryImages == null)
        model.galleryImages = temp;
      else {
        model.galleryImages.clear();
        model.galleryImages.addAll(temp);
      }
    }
    models.forEach((FactFileEntry model) => model.nuggets ??= []);
    await OneToXHelper.preloadAll<FactFileEntry, FactFileNugget>(
        models,
        (FactFileEntry model) => [model.id],
        factFileNuggetBean.findByFactFileEntryList,
        (FactFileNugget model) => [model.factFileEntryId],
        (FactFileEntry model, FactFileNugget child) =>
            model.nuggets = List.from(model.nuggets)..add(child),
        cascade: cascade);
    return models;
  }

  FactFileEntryImageBean get factFileEntryImageBean;

  MediaFileBean get mediaFileBean;
  FactFileNuggetBean get factFileNuggetBean;
  FactFileCategoryBean get factFileCategoryBean;
}
