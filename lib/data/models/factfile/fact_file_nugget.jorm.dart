// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_file_nugget.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _FactFileNuggetBean implements Bean<FactFileNugget> {
  final id = IntField('id');
  final factFileEntryId = IntField('fact_file_entry_id');
  final imageId = IntField('image_id');
  final orderIndex = IntField('order_index');
  final name = StrField('name');
  final text = StrField('text');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        factFileEntryId.name: factFileEntryId,
        imageId.name: imageId,
        orderIndex.name: orderIndex,
        name.name: name,
        text.name: text,
      };
  FactFileNugget fromMap(Map map) {
    FactFileNugget model = FactFileNugget();
    model.id = adapter.parseValue(map['id']);
    model.factFileEntryId = adapter.parseValue(map['fact_file_entry_id']);
    model.imageId = adapter.parseValue(map['image_id']);
    model.orderIndex = adapter.parseValue(map['order_index']);
    model.name = adapter.parseValue(map['name']);
    model.text = adapter.parseValue(map['text']);

    return model;
  }

  List<SetColumn> toSetColumns(FactFileNugget model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(factFileEntryId.set(model.factFileEntryId));
      ret.add(imageId.set(model.imageId));
      ret.add(orderIndex.set(model.orderIndex));
      ret.add(name.set(model.name));
      ret.add(text.set(model.text));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(factFileEntryId.name)) ret.add(factFileEntryId.set(model.factFileEntryId));
      if (only.contains(imageId.name)) ret.add(imageId.set(model.imageId));
      if (only.contains(orderIndex.name)) ret.add(orderIndex.set(model.orderIndex));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(text.name)) ret.add(text.set(model.text));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.factFileEntryId != null) {
        ret.add(factFileEntryId.set(model.factFileEntryId));
      }
      if (model.imageId != null) {
        ret.add(imageId.set(model.imageId));
      }
      if (model.orderIndex != null) {
        ret.add(orderIndex.set(model.orderIndex));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.text != null) {
        ret.add(text.set(model.text));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addInt(factFileEntryId.name, foreignTable: factFileEntryBean.tableName, foreignCol: 'id', isNullable: false);
    st.addInt(imageId.name, foreignTable: mediaFileBean.tableName, foreignCol: 'id', isNullable: true);
    st.addInt(orderIndex.name, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(text.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(FactFileNugget model,
      {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
    final Insert insert = inserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<FactFileNugget> models, {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model, only: only, onlyNonNull: onlyNonNull)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(FactFileNugget model,
      {bool cascade = false, Set<String> only, bool onlyNonNull = false}) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<FactFileNugget> models, {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(FactFileNugget model,
      {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false}) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<FactFileNugget> models, {bool onlyNonNull = false, Set<String> only}) async {
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

  Future<FactFileNugget> find(int id, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<FactFileNugget> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<FactFileNugget>> findByFactFileEntry(int factFileEntryId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.factFileEntryId.eq(factFileEntryId));
    return findMany(find);
  }

  Future<List<FactFileNugget>> findByFactFileEntryList(List<FactFileEntry> models,
      {bool preload = false, bool cascade = false}) async {
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

  void associateFactFileEntry(FactFileNugget child, FactFileEntry parent) {
    child.factFileEntryId = parent.id;
  }

  Future<List<FactFileNugget>> findByMediaFile(int imageId, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.imageId.eq(imageId));
    return findMany(find);
  }

  Future<List<FactFileNugget>> findByMediaFileList(List<MediaFile> models,
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

  void associateMediaFile(FactFileNugget child, MediaFile parent) {
    child.imageId = parent.id;
  }

  FactFileEntryBean get factFileEntryBean;
  MediaFileBean get mediaFileBean;
}
