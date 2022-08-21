// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_file_category.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _FactFileCategoryBean implements Bean<FactFileCategory> {
  final id = IntField('id');
  final name = StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
      };
  FactFileCategory fromMap(Map map) {
    FactFileCategory model = FactFileCategory();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(FactFileCategory model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(FactFileCategory model,
      {bool cascade = false, bool onlyNonNull = false, Set<String> only}) async {
    final Insert insert = inserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      FactFileCategory newModel;
      if (model.entries != null) {
        newModel ??= await find(model.id);
        model.entries.forEach((x) => factFileEntryBean.associateFactFileCategory(x, newModel));
        for (final child in model.entries) {
          await factFileEntryBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<FactFileCategory> models,
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

  Future<dynamic> upsert(FactFileCategory model,
      {bool cascade = false, Set<String> only, bool onlyNonNull = false}) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      FactFileCategory newModel;
      if (model.entries != null) {
        newModel ??= await find(model.id);
        model.entries.forEach((x) => factFileEntryBean.associateFactFileCategory(x, newModel));
        for (final child in model.entries) {
          await factFileEntryBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<FactFileCategory> models,
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

  Future<int> update(FactFileCategory model,
      {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false}) async {
    final Update update =
        updater.where(id.eq(model.id)).setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      FactFileCategory newModel;
      if (model.entries != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.entries.forEach((x) => factFileEntryBean.associateFactFileCategory(x, newModel));
        }
        for (final child in model.entries) {
          await factFileEntryBean.update(child, cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<FactFileCategory> models,
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

  Future<FactFileCategory> find(int id, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final FactFileCategory model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final FactFileCategory newModel = await find(id);
      if (newModel != null) {
        await factFileEntryBean.removeByFactFileCategory(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<FactFileCategory> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<FactFileCategory> preload(FactFileCategory model, {bool cascade = false}) async {
    model.entries = await factFileEntryBean.findByFactFileCategory(model.id, preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<FactFileCategory>> preloadAll(List<FactFileCategory> models, {bool cascade = false}) async {
    models.forEach((FactFileCategory model) => model.entries ??= []);
    await OneToXHelper.preloadAll<FactFileCategory, FactFileEntry>(
        models,
        (FactFileCategory model) => [model.id],
        factFileEntryBean.findByFactFileCategoryList,
        (FactFileEntry model) => [model.categoryId],
        (FactFileCategory model, FactFileEntry child) => model.entries = List.from(model.entries)..add(child),
        cascade: cascade);
    return models;
  }

  FactFileEntryBean get factFileEntryBean;
}
