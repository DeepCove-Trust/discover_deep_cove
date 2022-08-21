// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _ActivityBean implements Bean<Activity> {
  final id = IntField('id');
  final updatedAt = DateTimeField('updated_at');
  final trackId = IntField('track_id');
  final factFileId = IntField('fact_file_id');
  final _activityType = IntField('activity_type');
  final qrCode = StrField('qr_code');
  final coordX = DoubleField('coord_x');
  final coordY = DoubleField('coord_y');
  final title = StrField('title');
  final description = StrField('description');
  final task = StrField('task');
  final imageId = IntField('image_id');
  final userPhotoId = IntField('user_photo_id');
  final selectedPictureId = IntField('selected_picture_id');
  final informationActivityUnlocked = BoolField('information_activity_unlocked');
  final userCoordX = DoubleField('user_coord_x');
  final userCoordY = DoubleField('user_coord_y');
  final userCount = IntField('user_count');
  final userText = StrField('user_text');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        updatedAt.name: updatedAt,
        trackId.name: trackId,
        factFileId.name: factFileId,
        _activityType.name: _activityType,
        qrCode.name: qrCode,
        coordX.name: coordX,
        coordY.name: coordY,
        title.name: title,
        description.name: description,
        task.name: task,
        imageId.name: imageId,
        userPhotoId.name: userPhotoId,
        selectedPictureId.name: selectedPictureId,
        informationActivityUnlocked.name: informationActivityUnlocked,
        userCoordX.name: userCoordX,
        userCoordY.name: userCoordY,
        userCount.name: userCount,
        userText.name: userText,
      };
  Activity fromMap(Map map) {
    Activity model = Activity();
    model.id = adapter.parseValue(map['id']);
    model.updatedAt = adapter.parseValue(map['updated_at']);
    model.trackId = adapter.parseValue(map['track_id']);
    model.factFileId = adapter.parseValue(map['fact_file_id']);
    model._activityType = adapter.parseValue(map['activity_type']);
    model.qrCode = adapter.parseValue(map['qr_code']);
    model.coordX = adapter.parseValue(map['coord_x']);
    model.coordY = adapter.parseValue(map['coord_y']);
    model.title = adapter.parseValue(map['title']);
    model.description = adapter.parseValue(map['description']);
    model.task = adapter.parseValue(map['task']);
    model.imageId = adapter.parseValue(map['image_id']);
    model.userPhotoId = adapter.parseValue(map['user_photo_id']);
    model.selectedPictureId = adapter.parseValue(map['selected_picture_id']);
    model.informationActivityUnlocked = adapter.parseValue(map['information_activity_unlocked']);
    model.userCoordX = adapter.parseValue(map['user_coord_x']);
    model.userCoordY = adapter.parseValue(map['user_coord_y']);
    model.userCount = adapter.parseValue(map['user_count']);
    model.userText = adapter.parseValue(map['user_text']);

    return model;
  }

  List<SetColumn> toSetColumns(Activity model, {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(updatedAt.set(model.updatedAt));
      ret.add(trackId.set(model.trackId));
      ret.add(factFileId.set(model.factFileId));
      ret.add(_activityType.set(model._activityType));
      ret.add(qrCode.set(model.qrCode));
      ret.add(coordX.set(model.coordX));
      ret.add(coordY.set(model.coordY));
      ret.add(title.set(model.title));
      ret.add(description.set(model.description));
      ret.add(task.set(model.task));
      ret.add(imageId.set(model.imageId));
      ret.add(userPhotoId.set(model.userPhotoId));
      ret.add(selectedPictureId.set(model.selectedPictureId));
      ret.add(informationActivityUnlocked.set(model.informationActivityUnlocked));
      ret.add(userCoordX.set(model.userCoordX));
      ret.add(userCoordY.set(model.userCoordY));
      ret.add(userCount.set(model.userCount));
      ret.add(userText.set(model.userText));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(updatedAt.name)) ret.add(updatedAt.set(model.updatedAt));
      if (only.contains(trackId.name)) ret.add(trackId.set(model.trackId));
      if (only.contains(factFileId.name)) ret.add(factFileId.set(model.factFileId));
      if (only.contains(_activityType.name)) ret.add(_activityType.set(model._activityType));
      if (only.contains(qrCode.name)) ret.add(qrCode.set(model.qrCode));
      if (only.contains(coordX.name)) ret.add(coordX.set(model.coordX));
      if (only.contains(coordY.name)) ret.add(coordY.set(model.coordY));
      if (only.contains(title.name)) ret.add(title.set(model.title));
      if (only.contains(description.name)) ret.add(description.set(model.description));
      if (only.contains(task.name)) ret.add(task.set(model.task));
      if (only.contains(imageId.name)) ret.add(imageId.set(model.imageId));
      if (only.contains(userPhotoId.name)) ret.add(userPhotoId.set(model.userPhotoId));
      if (only.contains(selectedPictureId.name)) ret.add(selectedPictureId.set(model.selectedPictureId));
      if (only.contains(informationActivityUnlocked.name)) {
        ret.add(informationActivityUnlocked.set(model.informationActivityUnlocked));
      }
      if (only.contains(userCoordX.name)) ret.add(userCoordX.set(model.userCoordX));
      if (only.contains(userCoordY.name)) ret.add(userCoordY.set(model.userCoordY));
      if (only.contains(userCount.name)) ret.add(userCount.set(model.userCount));
      if (only.contains(userText.name)) ret.add(userText.set(model.userText));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.updatedAt != null) {
        ret.add(updatedAt.set(model.updatedAt));
      }
      if (model.trackId != null) {
        ret.add(trackId.set(model.trackId));
      }
      if (model.factFileId != null) {
        ret.add(factFileId.set(model.factFileId));
      }
      if (model._activityType != null) {
        ret.add(_activityType.set(model._activityType));
      }
      if (model.qrCode != null) {
        ret.add(qrCode.set(model.qrCode));
      }
      if (model.coordX != null) {
        ret.add(coordX.set(model.coordX));
      }
      if (model.coordY != null) {
        ret.add(coordY.set(model.coordY));
      }
      if (model.title != null) {
        ret.add(title.set(model.title));
      }
      if (model.description != null) {
        ret.add(description.set(model.description));
      }
      if (model.task != null) {
        ret.add(task.set(model.task));
      }
      if (model.imageId != null) {
        ret.add(imageId.set(model.imageId));
      }
      if (model.userPhotoId != null) {
        ret.add(userPhotoId.set(model.userPhotoId));
      }
      if (model.selectedPictureId != null) {
        ret.add(selectedPictureId.set(model.selectedPictureId));
      }
      if (model.informationActivityUnlocked != null) {
        ret.add(informationActivityUnlocked.set(model.informationActivityUnlocked));
      }
      if (model.userCoordX != null) {
        ret.add(userCoordX.set(model.userCoordX));
      }
      if (model.userCoordY != null) {
        ret.add(userCoordY.set(model.userCoordY));
      }
      if (model.userCount != null) {
        ret.add(userCount.set(model.userCount));
      }
      if (model.userText != null) {
        ret.add(userText.set(model.userText));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addDateTime(updatedAt.name, isNullable: false);
    st.addInt(trackId.name, foreignTable: trackBean.tableName, foreignCol: 'id', isNullable: false);
    st.addInt(factFileId.name, isNullable: true);
    st.addInt(_activityType.name, isNullable: false);
    st.addStr(qrCode.name, isNullable: false);
    st.addDouble(coordX.name, isNullable: false);
    st.addDouble(coordY.name, isNullable: false);
    st.addStr(title.name, isNullable: false);
    st.addStr(description.name, isNullable: false);
    st.addStr(task.name, isNullable: true);
    st.addInt(imageId.name, foreignTable: mediaFileBean.tableName, foreignCol: 'id', isNullable: true);
    st.addInt(userPhotoId.name, foreignTable: userPhotoBean.tableName, foreignCol: 'id', isNullable: true);
    st.addInt(selectedPictureId.name, foreignTable: mediaFileBean.tableName, foreignCol: 'id', isNullable: true);
    st.addBool(informationActivityUnlocked.name, isNullable: false);
    st.addDouble(userCoordX.name, isNullable: true);
    st.addDouble(userCoordY.name, isNullable: true);
    st.addInt(userCount.name, isNullable: true);
    st.addStr(userText.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Activity model, {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
    final Insert insert = inserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Activity newModel;
      if (model.imageOptions != null) {
        newModel ??= await find(model.id);
        for (final child in model.imageOptions) {
          await mediaFileBean.insert(child, cascade: cascade);
          await activityImageBean.attach(child, newModel);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Activity> models,
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

  Future<dynamic> upsert(Activity model, {bool cascade = false, Set<String> only, bool onlyNonNull = false}) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Activity newModel;
      if (model.imageOptions != null) {
        newModel ??= await find(model.id);
        for (final child in model.imageOptions) {
          await mediaFileBean.upsert(child, cascade: cascade);
          await activityImageBean.attach(child, newModel, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Activity> models,
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

  Future<int> update(Activity model,
      {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false}) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      // ignore: unused_local_variable
      Activity newModel;
      if (model.imageOptions != null) {
        for (final child in model.imageOptions) {
          await mediaFileBean.update(child, cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Activity> models,
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
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Activity> find(int id, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Activity model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Activity newModel = await find(id);
      if (newModel != null) {
        await activityImageBean.detachActivity(newModel);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Activity> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Activity>> findByTrack(int trackId, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.trackId.eq(trackId));
    final List<Activity> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<Activity>> findByTrackList(List<Track> models, {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Track model in models) {
      find.or(this.trackId.eq(model.id));
    }
    final List<Activity> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByTrack(int trackId) async {
    final Remove rm = remover.where(this.trackId.eq(trackId));
    return await adapter.remove(rm);
  }

  void associateTrack(Activity child, Track parent) {
    child.trackId = parent.id;
  }

  Future<List<Activity>> findByMediaFile(int imageId, int selectedPictureId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.imageId.eq(imageId)).where(this.selectedPictureId.eq(selectedPictureId));
    final List<Activity> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<Activity>> findByMediaFileList(List<MediaFile> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (MediaFile model in models) {
      find.or(this.imageId.eq(model.id) & this.selectedPictureId.eq(model.id));
    }
    final List<Activity> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByMediaFile(int imageId, int selectedPictureId) async {
    final Remove rm = remover.where(this.imageId.eq(imageId)).where(this.selectedPictureId.eq(selectedPictureId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(Activity child, MediaFile parent) {
    child.imageId = parent.id;
    child.selectedPictureId = parent.id;
  }

  Future<List<Activity>> findByUserPhoto(int userPhotoId, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.userPhotoId.eq(userPhotoId));
    final List<Activity> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<Activity>> findByUserPhotoList(List<UserPhoto> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (UserPhoto model in models) {
      find.or(this.userPhotoId.eq(model.id));
    }
    final List<Activity> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByUserPhoto(int userPhotoId) async {
    final Remove rm = remover.where(this.userPhotoId.eq(userPhotoId));
    return await adapter.remove(rm);
  }

  void associateUserPhoto(Activity child, UserPhoto parent) {
    child.userPhotoId = parent.id;
  }

  Future<Activity> preload(Activity model, {bool cascade = false}) async {
    model.imageOptions = await activityImageBean.fetchByActivity(model);
    return model;
  }

  Future<List<Activity>> preloadAll(List<Activity> models, {bool cascade = false}) async {
    for (Activity model in models) {
      var temp = await activityImageBean.fetchByActivity(model);
      if (model.imageOptions == null) {
        model.imageOptions = temp;
      } else {
        model.imageOptions.clear();
        model.imageOptions.addAll(temp);
      }
    }
    return models;
  }

  ActivityImageBean get activityImageBean;

  MediaFileBean get mediaFileBean;
  TrackBean get trackBean;
  UserPhotoBean get userPhotoBean;
}
