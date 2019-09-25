// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_file_entry_image.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _FactFileEntryImageBean implements Bean<FactFileEntryImage> {
  final factFileEntryId = IntField('fact_file_entry_id');
  final mediaFileId = IntField('media_file_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        factFileEntryId.name: factFileEntryId,
        mediaFileId.name: mediaFileId,
      };
  FactFileEntryImage fromMap(Map map) {
    FactFileEntryImage model = FactFileEntryImage();
    model.factFileEntryId = adapter.parseValue(map['fact_file_entry_id']);
    model.mediaFileId = adapter.parseValue(map['media_file_id']);

    return model;
  }

  List<SetColumn> toSetColumns(FactFileEntryImage model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(factFileEntryId.set(model.factFileEntryId));
      ret.add(mediaFileId.set(model.mediaFileId));
    } else if (only != null) {
      if (only.contains(factFileEntryId.name))
        ret.add(factFileEntryId.set(model.factFileEntryId));
      if (only.contains(mediaFileId.name))
        ret.add(mediaFileId.set(model.mediaFileId));
    } else /* if (onlyNonNull) */ {
      if (model.factFileEntryId != null) {
        ret.add(factFileEntryId.set(model.factFileEntryId));
      }
      if (model.mediaFileId != null) {
        ret.add(mediaFileId.set(model.mediaFileId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(factFileEntryId.name,
        foreignTable: factFileEntryBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addInt(mediaFileId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(FactFileEntryImage model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<FactFileEntryImage> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(FactFileEntryImage model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<FactFileEntryImage> models,
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

  Future<void> updateMany(List<FactFileEntryImage> models,
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

  Future<List<FactFileEntryImage>> findByFactFileEntry(int factFileEntryId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.factFileEntryId.eq(factFileEntryId));
    return findMany(find);
  }

  Future<List<FactFileEntryImage>> findByFactFileEntryList(
      List<FactFileEntry> models,
      {bool preload = false,
      bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (FactFileEntry model in models) {
      find.or(this.factFileEntryId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByFactFileEntry(int factFileEntryId) async {
    final Remove rm = remover.where(this.factFileEntryId.eq(factFileEntryId));
    return await adapter.remove(rm);
  }

  void associateFactFileEntry(FactFileEntryImage child, FactFileEntry parent) {
    child.factFileEntryId = parent.id;
  }

  Future<int> detachFactFileEntry(FactFileEntry model) async {
    final dels = await findByFactFileEntry(model.id);
    if (dels.isNotEmpty) {
      await removeByFactFileEntry(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(mediaFileBean.id.eq(t.mediaFileId));
      }
      return await mediaFileBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<MediaFile>> fetchByFactFileEntry(FactFileEntry model) async {
    final pivots = await findByFactFileEntry(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(mediaFileBean.id.eq(t.mediaFileId));
    }
    return await mediaFileBean.findWhere(exp);
  }

  Future<List<FactFileEntryImage>> findByMediaFile(int mediaFileId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.mediaFileId.eq(mediaFileId));
    return findMany(find);
  }

  Future<List<FactFileEntryImage>> findByMediaFileList(List<MediaFile> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (MediaFile model in models) {
      find.or(this.mediaFileId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByMediaFile(int mediaFileId) async {
    final Remove rm = remover.where(this.mediaFileId.eq(mediaFileId));
    return await adapter.remove(rm);
  }

  void associateMediaFile(FactFileEntryImage child, MediaFile parent) {
    child.mediaFileId = parent.id;
  }

  Future<int> detachMediaFile(MediaFile model) async {
    final dels = await findByMediaFile(model.id);
    if (dels.isNotEmpty) {
      await removeByMediaFile(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(factFileEntryBean.id.eq(t.factFileEntryId));
      }
      return await factFileEntryBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<FactFileEntry>> fetchByMediaFile(MediaFile model) async {
    final pivots = await findByMediaFile(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(factFileEntryBean.id.eq(t.factFileEntryId));
    }
    return await factFileEntryBean.findWhere(exp);
  }

  Future<dynamic> attach(MediaFile one, FactFileEntry two,
      {bool upsert = false}) async {
    final ret = FactFileEntryImage();
    ret.mediaFileId = one.id;
    ret.factFileEntryId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  FactFileEntryBean get factFileEntryBean;
  MediaFileBean get mediaFileBean;
}
