import 'package:meta/meta.dart';

import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

import 'package:discover_deep_cove/data/models/fact_file_category.dart';

part 'fact_file_entry.jorm.dart';

/// An entry in the 'Deep Cove Factfiles'
class FactFileEntry {
  /// Used by bean only. Use FactFileEntry.make() instead.
  FactFileEntry();

  FactFileEntry.make(
      {@required this.id,
      @required this.categoryId,
      @required this.title,
      @required this.content});

  @PrimaryKey()
  int id;

  @BelongsTo(FactFileCategoryBean)
  int categoryId;

  @Column()
  String title;

  @Column()
  String content;
}

/// Bean class for database manipulation - generated mixin code
@GenBean()
class FactFileEntryBean extends Bean<FactFileEntry> with _FactFileEntryBean {
  FactFileEntryBean(Adapter adapter) : super(adapter);

  FactFileCategoryBean _factFileCategoryBean;
  FactFileCategoryBean get factFileCategoryBean =>
      _factFileCategoryBean ??= FactFileCategoryBean(adapter);

  final String tableName = 'fact_file_entries';
}
