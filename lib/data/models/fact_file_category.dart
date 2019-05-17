import 'package:meta/meta.dart';

import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

import 'package:discover_deep_cove/data/models/fact_file_entry.dart';

part 'fact_file_category.jorm.dart';

/// A category that a [FactFileEntry] may belong to.
class FactFileCategory{
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
    with _FactFileCategoryBean{
  FactFileCategoryBean(Adapter adapter) : factFileEntryBean = FactFileEntryBean(adapter), super(adapter);

  final FactFileEntryBean factFileEntryBean;

  final String tableName = 'fact_file_categories';

}