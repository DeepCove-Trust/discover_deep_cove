// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _MediaFileBean implements Bean<MediaFile> {
  final id = IntField('id');
  final type = StrField('type');
  final description = StrField('description');
  final path = StrField('path');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        type.name: type,
        description.name: description,
        path.name: path,
      };
  MediaFile fromMap(Map map) {
    MediaFile model = MediaFile();
    model.id = adapter.parseValue(map['id']);
    model.type = adapter.parseValue(map['type']);
    model.description = adapter.parseValue(map['description']);
    model.path = adapter.parseValue(map['path']);

    return model;
  }

  List<SetColumn> toSetColumns(MediaFile model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(type.set(model.type));
      ret.add(description.set(model.description));
      ret.add(path.set(model.path));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(type.name)) ret.add(type.set(model.type));
      if (only.contains(description.name))
        ret.add(description.set(model.description));
      if (only.contains(path.name)) ret.add(path.set(model.path));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.type != null) {
        ret.add(type.set(model.type));
      }
      if (model.description != null) {
        ret.add(description.set(model.description));
      }
      if (model.path != null) {
        ret.add(path.set(model.path));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(type.name, isNullable: false);
    st.addStr(description.name, isNullable: false);
    st.addStr(path.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(MediaFile model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      MediaFile newModel;
      if (model.mainImageEntries != null) {
        newModel ??= await find(model.id);
        model.mainImageEntries
            .forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.mainImageEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
        }
      }
      if (model.birdCallEntries != null) {
        newModel ??= await find(model.id);
        model.birdCallEntries
            .forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.birdCallEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
        }
      }
      if (model.pronunciationEntries != null) {
        newModel ??= await find(model.id);
        model.pronunciationEntries
            .forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.pronunciationEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
        }
      }
      if (model.galleryImageEntries != null) {
        newModel ??= await find(model.id);
        for (final child in model.galleryImageEntries) {
          await factFileEntryBean.insert(child, cascade: cascade);
          await entryToMediaPivotBean.attach(newModel, child);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<MediaFile> models,
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

  Future<dynamic> upsert(MediaFile model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      MediaFile newModel;
      if (model.mainImageEntries != null) {
        newModel ??= await find(model.id);
        model.mainImageEntries
            .forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.mainImageEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
        }
      }
      if (model.birdCallEntries != null) {
        newModel ??= await find(model.id);
        model.birdCallEntries
            .forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.birdCallEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
        }
      }
      if (model.pronunciationEntries != null) {
        newModel ??= await find(model.id);
        model.pronunciationEntries
            .forEach((x) => factFileEntryBean.associateMediaFile(x, newModel));
        for (final child in model.pronunciationEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
        }
      }
      if (model.galleryImageEntries != null) {
        newModel ??= await find(model.id);
        for (final child in model.galleryImageEntries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
          await entryToMediaPivotBean.attach(newModel, child, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<MediaFile> models,
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

  Future<int> update(MediaFile model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      MediaFile newModel;
      if (model.mainImageEntries != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.mainImageEntries.forEach(
              (x) => factFileEntryBean.associateMediaFile(x, newModel));
        }
        for (final child in model.mainImageEntries) {
          await factFileEntryBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.birdCallEntries != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.birdCallEntries.forEach(
              (x) => factFileEntryBean.associateMediaFile(x, newModel));
        }
        for (final child in model.birdCallEntries) {
          await factFileEntryBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.pronunciationEntries != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.pronunciationEntries.forEach(
              (x) => factFileEntryBean.associateMediaFile(x, newModel));
        }
        for (final child in model.pronunciationEntries) {
          await factFileEntryBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.galleryImageEntries != null) {
        for (final child in model.galleryImageEntries) {
          await factFileEntryBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<MediaFile> models,
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

  Future<MediaFile> find(int id,
      {bool preload = false, bool cascade = false}) async {
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
        await factFileEntryBean.removeByMediaFile(
            newModel.id, newModel.id, newModel.id);
        await factFileEntryBean.removeByMediaFile(
            newModel.id, newModel.id, newModel.id);
        await factFileEntryBean.removeByMediaFile(
            newModel.id, newModel.id, newModel.id);
        await entryToMediaPivotBean.detachMediaFile(newModel);
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
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<MediaFile> preload(MediaFile model, {bool cascade = false}) async {
    model.mainImageEntries = await factFileEntryBean.findByMediaFile(
        model.id, model.id, model.id,
        preload: cascade, cascade: cascade);
    model.birdCallEntries = await factFileEntryBean.findByMediaFile(
        model.id, model.id, model.id,
        preload: cascade, cascade: cascade);
    model.pronunciationEntries = await factFileEntryBean.findByMediaFile(
        model.id, model.id, model.id,
        preload: cascade, cascade: cascade);
    model.galleryImageEntries =
        await entryToMediaPivotBean.fetchByMediaFile(model);
    return model;
  }

  Future<List<MediaFile>> preloadAll(List<MediaFile> models,
      {bool cascade = false}) async {
    models.forEach((MediaFile model) => model.mainImageEntries ??= []);
    await OneToXHelper.preloadAll<MediaFile, FactFileEntry>(
        models,
        (MediaFile model) => [model.id, model.id, model.id],
        factFileEntryBean.findByMediaFileList,
        (FactFileEntry model) => [
              model.mainImageId,
              model.pronunciationAudioId,
              model.listenAudioId
            ],
        (MediaFile model, FactFileEntry child) => model.mainImageEntries =
            List.from(model.mainImageEntries)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.birdCallEntries ??= []);
    await OneToXHelper.preloadAll<MediaFile, FactFileEntry>(
        models,
        (MediaFile model) => [model.id, model.id, model.id],
        factFileEntryBean.findByMediaFileList,
        (FactFileEntry model) => [
              model.mainImageId,
              model.pronunciationAudioId,
              model.listenAudioId
            ],
        (MediaFile model, FactFileEntry child) => model.birdCallEntries =
            List.from(model.birdCallEntries)..add(child),
        cascade: cascade);
    models.forEach((MediaFile model) => model.pronunciationEntries ??= []);
    await OneToXHelper.preloadAll<MediaFile, FactFileEntry>(
        models,
        (MediaFile model) => [model.id, model.id, model.id],
        factFileEntryBean.findByMediaFileList,
        (FactFileEntry model) => [
              model.mainImageId,
              model.pronunciationAudioId,
              model.listenAudioId
            ],
        (MediaFile model, FactFileEntry child) => model.pronunciationEntries =
            List.from(model.pronunciationEntries)..add(child),
        cascade: cascade);
    for (MediaFile model in models) {
      var temp = await entryToMediaPivotBean.fetchByMediaFile(model);
      if (model.galleryImageEntries == null)
        model.galleryImageEntries = temp;
      else {
        model.galleryImageEntries.clear();
        model.galleryImageEntries.addAll(temp);
      }
    }
    return models;
  }

  FactFileEntryBean get factFileEntryBean;
  EntryToMediaPivotBean get entryToMediaPivotBean;
}
