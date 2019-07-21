import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:meta/meta.dart';

part 'fact_file_category.jorm.dart';

/// A category that a [FactFileEntry] may belong to.
class FactFileCategory {
  /// Used by bean only. Use FactFileCategory.make() instead.
  FactFileCategory();

  FactFileCategory.make({@required this.id, @required this.name});

  @PrimaryKey()
  int id;

  @Column()
  String name;

  @HasMany(FactFileEntryBean)
  List<FactFileEntry> entries;

  @override
  String toString() => 'Fact File Category( id: $id, name: $name)';
}

/// Bean class for database manipulation - generated mixin code
@GenBean()
class FactFileCategoryBean extends Bean<FactFileCategory>
    with _FactFileCategoryBean {
  FactFileCategoryBean(Adapter adapter)
      : factFileEntryBean = FactFileEntryBean(adapter),
        super(adapter);

  FactFileCategoryBean.of(BuildContext context)
      : factFileEntryBean = FactFileEntryBean(DatabaseAdapter.of(context)),
        super(DatabaseAdapter.of(context));

  final FactFileEntryBean factFileEntryBean;

  final String tableName = 'fact_file_categories';

  // Pre-loads all categories with their entries, and in turn preloads all
  // entries with their media files.
  Future<List<FactFileCategory>> getAllWithPreloadedEntries() async {

    List<FactFileCategory> categories = await getAll();
    categories = await preloadAll(categories);

    for(FactFileCategory category in categories){
      await factFileEntryBean.preloadAll(category.entries);
      await factFileEntryBean.preloadExtras(category.entries);
    }
    return categories;
  }
}
