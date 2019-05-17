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
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        categoryId.name: categoryId,
        title.name: title,
        content.name: content,
      };
  FactFileEntry fromMap(Map map) {
    FactFileEntry model = FactFileEntry();
    model.id = adapter.parseValue(map['id']);
    model.categoryId = adapter.parseValue(map['category_id']);
    model.title = adapter.parseValue(map['title']);
    model.content = adapter.parseValue(map['content']);

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
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(categoryId.name))
        ret.add(categoryId.set(model.categoryId));
      if (only.contains(title.name)) ret.add(title.set(model.title));
      if (only.contains(content.name)) ret.add(content.set(model.content));
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
    return adapter.createTable(st);
  }

  Future<dynamic> insert(FactFileEntry model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<FactFileEntry> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(FactFileEntry model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<FactFileEntry> models,
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

  Future<int> update(FactFileEntry model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<FactFileEntry> models,
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

  Future<FactFileEntry> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
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
    return findMany(find);
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
    return findMany(find);
  }

  Future<int> removeByFactFileCategory(int categoryId) async {
    final Remove rm = remover.where(this.categoryId.eq(categoryId));
    return await adapter.remove(rm);
  }

  void associateFactFileCategory(FactFileEntry child, FactFileCategory parent) {
    child.categoryId = parent.id;
  }

  FactFileCategoryBean get factFileCategoryBean;
}
