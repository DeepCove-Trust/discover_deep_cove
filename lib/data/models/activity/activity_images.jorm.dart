// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_images.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _ActivityImageBean implements Bean<ActivityImage> {
  final activityId = IntField('activity_id');
  final imageId = IntField('image_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        activityId.name: activityId,
        imageId.name: imageId,
      };
  ActivityImage fromMap(Map map) {
    ActivityImage model = ActivityImage();
    model.activityId = adapter.parseValue(map['activity_id']);
    model.imageId = adapter.parseValue(map['image_id']);

    return model;
  }

  List<SetColumn> toSetColumns(ActivityImage model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(activityId.set(model.activityId));
      ret.add(imageId.set(model.imageId));
    } else if (only != null) {
      if (only.contains(activityId.name))
        ret.add(activityId.set(model.activityId));
      if (only.contains(imageId.name)) ret.add(imageId.set(model.imageId));
    } else /* if (onlyNonNull) */ {
      if (model.activityId != null) {
        ret.add(activityId.set(model.activityId));
      }
      if (model.imageId != null) {
        ret.add(imageId.set(model.imageId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(activityId.name,
        foreignTable: activityBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addInt(imageId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(ActivityImage model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<ActivityImage> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(ActivityImage model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<ActivityImage> models,
      {bool onlyNonNull = false, Set<String> only}) async {
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

  Future<void> updateMany(List<ActivityImage> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(null);
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<List<ActivityImage>> findByActivity(int activityId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.activityId.eq(activityId));
    return findMany(find);
  }

  Future<List<ActivityImage>> findByActivityList(List<Activity> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Activity model in models) {
      find.or(this.activityId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByActivity(int activityId) async {
    final Remove rm = remover.where(this.activityId.eq(activityId));
    return await adapter.remove(rm);
  }

  void associateActivity(ActivityImage child, Activity parent) {
    child.activityId = parent.id;
  }

  Future<int> detachActivity(Activity model) async {
    final dels = await findByActivity(model.id);
    if (dels.isNotEmpty) {
      await removeByActivity(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(mediaFileBean.id.eq(t.imageId));
      }
      return await mediaFileBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<MediaFile>> fetchByActivity(Activity model) async {
    final pivots = await findByActivity(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(mediaFileBean.id.eq(t.imageId));
    }
    return await mediaFileBean.findWhere(exp);
  }

  Future<List<ActivityImage>> findByMediaFile(int imageId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.imageId.eq(imageId));
    return findMany(find);
  }

  Future<List<ActivityImage>> findByMediaFileList(List<MediaFile> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (MediaFile model in models) {
      find.or(this.imageId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByMediaFile(int imageId) async {
    final Remove rm = remover.where(this.imageId.eq(imageId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(ActivityImage child, MediaFile parent) {
    child.imageId = parent.id;
  }

  Future<int> detachMediaFile(MediaFile model) async {
    final dels = await findByMediaFile(model.id);
    if (dels.isNotEmpty) {
      await removeByMediaFile(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(activityBean.id.eq(t.activityId));
      }
      return await activityBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Activity>> fetchByMediaFile(MediaFile model) async {
    final pivots = await findByMediaFile(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(activityBean.id.eq(t.activityId));
    }
    return await activityBean.findWhere(exp);
  }

  Future<dynamic> attach(MediaFile one, Activity two,
      {bool upsert = false}) async {
    final ret = ActivityImage();
    ret.imageId = one.id;
    ret.activityId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  ActivityBean get activityBean;
  MediaFileBean get mediaFileBean;
}
