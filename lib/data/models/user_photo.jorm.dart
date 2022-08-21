// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_photo.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserPhotoBean implements Bean<UserPhoto> {
  final id = IntField('id');
  final path = StrField('path');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        path.name: path,
      };
  UserPhoto fromMap(Map map) {
    UserPhoto model = UserPhoto();
    model.id = adapter.parseValue(map['id']);
    model.path = adapter.parseValue(map['path']);

    return model;
  }

  List<SetColumn> toSetColumns(UserPhoto model, {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(path.set(model.path));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(path.name)) ret.add(path.set(model.path));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.path != null) {
        ret.add(path.set(model.path));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, autoIncrement: true, isNullable: false);
    st.addStr(path.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(UserPhoto model, {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
    final Insert insert = inserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull)).id(id.name);
    var retId = await adapter.insert(insert);
    if (cascade) {
      UserPhoto newModel;
      if (model.activities != null) {
        newModel ??= await find(retId);
        model.activities.forEach((x) => activityBean.associateUserPhoto(x, newModel));
        for (final child in model.activities) {
          await activityBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<UserPhoto> models,
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

  Future<dynamic> upsert(UserPhoto model, {bool cascade = false, Set<String> only, bool onlyNonNull = false}) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull)).id(id.name);
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      UserPhoto newModel;
      if (model.activities != null) {
        newModel ??= await find(retId);
        model.activities.forEach((x) => activityBean.associateUserPhoto(x, newModel));
        for (final child in model.activities) {
          await activityBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<UserPhoto> models,
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

  Future<int> update(UserPhoto model,
      {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false}) async {
    final Update update =
        updater.where(id.eq(model.id)).setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      UserPhoto newModel;
      if (model.activities != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.activities.forEach((x) => activityBean.associateUserPhoto(x, newModel));
        }
        for (final child in model.activities) {
          await activityBean.update(child, cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<UserPhoto> models,
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

  Future<UserPhoto> find(int id, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final UserPhoto model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final UserPhoto newModel = await find(id);
      if (newModel != null) {
        await activityBean.removeByUserPhoto(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<UserPhoto> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<UserPhoto> preload(UserPhoto model, {bool cascade = false}) async {
    model.activities = await activityBean.findByUserPhoto(model.id, preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<UserPhoto>> preloadAll(List<UserPhoto> models, {bool cascade = false}) async {
    models.forEach((UserPhoto model) => model.activities ??= []);
    await OneToXHelper.preloadAll<UserPhoto, Activity>(
        models,
        (UserPhoto model) => [model.id],
        activityBean.findByUserPhotoList,
        (Activity model) => [model.userPhotoId],
        (UserPhoto model, Activity child) => model.activities = List.from(model.activities)..add(child),
        cascade: cascade);
    return models;
  }

  ActivityBean get activityBean;
}
