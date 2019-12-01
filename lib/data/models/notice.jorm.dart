// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _NoticeBean implements Bean<Notice> {
  final id = IntField('id');
  final urgent = BoolField('urgent');
  final dismissed = BoolField('dismissed');
  final imageId = IntField('image_id');
  final updatedAt = DateTimeField('updated_at');
  final title = StrField('title');
  final shortDesc = StrField('short_desc');
  final longDesc = StrField('long_desc');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        urgent.name: urgent,
        dismissed.name: dismissed,
        imageId.name: imageId,
        updatedAt.name: updatedAt,
        title.name: title,
        shortDesc.name: shortDesc,
        longDesc.name: longDesc,
      };
  Notice fromMap(Map map) {
    Notice model = Notice();
    model.id = adapter.parseValue(map['id']);
    model.urgent = adapter.parseValue(map['urgent']);
    model.dismissed = adapter.parseValue(map['dismissed']);
    model.imageId = adapter.parseValue(map['image_id']);
    model.updatedAt = adapter.parseValue(map['updated_at']);
    model.title = adapter.parseValue(map['title']);
    model.shortDesc = adapter.parseValue(map['short_desc']);
    model.longDesc = adapter.parseValue(map['long_desc']);

    return model;
  }

  List<SetColumn> toSetColumns(Notice model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(urgent.set(model.urgent));
      ret.add(dismissed.set(model.dismissed));
      ret.add(imageId.set(model.imageId));
      ret.add(updatedAt.set(model.updatedAt));
      ret.add(title.set(model.title));
      ret.add(shortDesc.set(model.shortDesc));
      ret.add(longDesc.set(model.longDesc));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(urgent.name)) ret.add(urgent.set(model.urgent));
      if (only.contains(dismissed.name))
        ret.add(dismissed.set(model.dismissed));
      if (only.contains(imageId.name)) ret.add(imageId.set(model.imageId));
      if (only.contains(updatedAt.name))
        ret.add(updatedAt.set(model.updatedAt));
      if (only.contains(title.name)) ret.add(title.set(model.title));
      if (only.contains(shortDesc.name))
        ret.add(shortDesc.set(model.shortDesc));
      if (only.contains(longDesc.name)) ret.add(longDesc.set(model.longDesc));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.urgent != null) {
        ret.add(urgent.set(model.urgent));
      }
      if (model.dismissed != null) {
        ret.add(dismissed.set(model.dismissed));
      }
      if (model.imageId != null) {
        ret.add(imageId.set(model.imageId));
      }
      if (model.updatedAt != null) {
        ret.add(updatedAt.set(model.updatedAt));
      }
      if (model.title != null) {
        ret.add(title.set(model.title));
      }
      if (model.shortDesc != null) {
        ret.add(shortDesc.set(model.shortDesc));
      }
      if (model.longDesc != null) {
        ret.add(longDesc.set(model.longDesc));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addBool(urgent.name, isNullable: false);
    st.addBool(dismissed.name, isNullable: false);
    st.addInt(imageId.name,
        foreignTable: mediaFileBean.tableName,
        foreignCol: 'id',
        isNullable: true);
    st.addDateTime(updatedAt.name, isNullable: false);
    st.addStr(title.name, isNullable: false);
    st.addStr(shortDesc.name, isNullable: false);
    st.addStr(longDesc.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Notice model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Notice> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Notice model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Notice> models,
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

  Future<int> update(Notice model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Notice> models,
      {bool onlyNonNull = false, Set<String> only}) async {
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

  Future<Notice> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Notice> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Notice>> findByMediaFile(int imageId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.imageId.eq(imageId));
    return findMany(find);
  }

  Future<List<Notice>> findByMediaFileList(List<MediaFile> models,
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

  void associateMediaFile(Notice child, MediaFile parent) {
    child.imageId = parent.id;
  }

  MediaFileBean get mediaFileBean;
}
