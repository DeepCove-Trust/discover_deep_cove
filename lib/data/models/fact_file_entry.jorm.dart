// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_file_entry.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _FactFileEntryBean implements Bean<FactFileEntry> {
  final id = IntField('id');
  final categoryId = IntField('category_id');
  final title = StrField('title');
  final content = StrField('content');
  final mainImageId = IntField('main_image_id');
  final pronunciationAudioId = IntField('pronunciation_audio_id');
  final birdCallAudioId = IntField('bird_call_audio_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        categoryId.name: categoryId,
        title.name: title,
        content.name: content,
        mainImageId.name: mainImageId,
        pronunciationAudioId.name: pronunciationAudioId,
        birdCallAudioId.name: birdCallAudioId,
      };
  FactFileEntry fromMap(Map map) {
    FactFileEntry model = FactFileEntry();
    model.id = adapter.parseValue(map['id']);
    model.categoryId = adapter.parseValue(map['category_id']);
    model.title = adapter.parseValue(map['title']);
    model.content = adapter.parseValue(map['content']);
    model.mainImageId = adapter.parseValue(map['main_image_id']);
    model.pronunciationAudioId =
        adapter.parseValue(map['pronunciation_audio_id']);
    model.birdCallAudioId = adapter.parseValue(map['bird_call_audio_id']);

    return model;
  }

  List<SetColumn> toSetColumns(FactFileEntry model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(categoryId.set(model.categoryId));
      ret.add(title.set(model.title));
      ret.add(content.set(model.content));
      ret.add(mainImageId.set(model.mainImageId));
      ret.add(pronunciationAudioId.set(model.pronunciationAudioId));
      ret.add(birdCallAudioId.set(model.birdCallAudioId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(categoryId.name))
        ret.add(categoryId.set(model.categoryId));
      if (only.contains(title.name)) ret.add(title.set(model.title));
      if (only.contains(content.name)) ret.add(content.set(model.content));
      if (only.contains(mainImageId.name))
        ret.add(mainImageId.set(model.mainImageId));
      if (only.contains(pronunciationAudioId.name))
        ret.add(pronunciationAudioId.set(model.pronunciationAudioId));
      if (only.contains(birdCallAudioId.name))
        ret.add(birdCallAudioId.set(model.birdCallAudioId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.categoryId != null) {
        ret.add(categoryId.set(model.categoryId));
      }
      if (model.title != null) {
        ret.add(title.set(model.title));
      }
      if (model.content != null) {
        ret.add(content.set(model.content));
      }
      if (model.mainImageId != null) {
        ret.add(mainImageId.set(model.mainImageId));
      }
      if (model.pronunciationAudioId != null) {
        ret.add(pronunciationAudioId.set(model.pronunciationAudioId));
      }
      if (model.birdCallAudioId != null) {
        ret.add(birdCallAudioId.set(model.birdCallAudioId));
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
    st.addStr(title.name, isNullable: false);
    st.addStr(content.name, isNullable: false);
    st.addInt(mainImageId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addInt(pronunciationAudioId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addInt(birdCallAudioId.name,
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
          await entryToMediaPivotBean.attach(child, newModel);
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
          await entryToMediaPivotBean.attach(child, newModel, upsert: true);
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
        await entryToMediaPivotBean.detachFactFileEntry(newModel);
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
      int mainImageId, int pronunciationAudioId, int birdCallAudioId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder
        .where(this.mainImageId.eq(mainImageId))
        .where(this.pronunciationAudioId.eq(pronunciationAudioId))
        .where(this.birdCallAudioId.eq(birdCallAudioId));
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
          this.pronunciationAudioId.eq(model.id) &
          this.birdCallAudioId.eq(model.id));
    }
    final List<FactFileEntry> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByMediaFile(
      int mainImageId, int pronunciationAudioId, int birdCallAudioId) async {
    final Remove rm = remover
        .where(this.mainImageId.eq(mainImageId))
        .where(this.pronunciationAudioId.eq(pronunciationAudioId))
        .where(this.birdCallAudioId.eq(birdCallAudioId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(FactFileEntry child, MediaFile parent) {
    child.mainImageId = parent.id;
    child.pronunciationAudioId = parent.id;
    child.birdCallAudioId = parent.id;
  }

  Future<FactFileEntry> preload(FactFileEntry model,
      {bool cascade = false}) async {
    model.galleryImages =
        await entryToMediaPivotBean.fetchByFactFileEntry(model);
    return model;
  }

  Future<List<FactFileEntry>> preloadAll(List<FactFileEntry> models,
      {bool cascade = false}) async {
    for (FactFileEntry model in models) {
      var temp = await entryToMediaPivotBean.fetchByFactFileEntry(model);
      if (model.galleryImages == null)
        model.galleryImages = temp;
      else {
        model.galleryImages.clear();
        model.galleryImages.addAll(temp);
      }
    }
    return models;
  }

  EntryToMediaPivotBean get entryToMediaPivotBean;

  MediaFileBean get mediaFileBean;
  FactFileCategoryBean get factFileCategoryBean;
}
