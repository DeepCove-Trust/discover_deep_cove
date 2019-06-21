import 'package:discover_deep_cove/data/models/factfile/entry_media_pivot.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:meta/meta.dart';

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

  @BelongsTo(MediaFileBean)
  int mainImageId;

  @BelongsTo(MediaFileBean)
  int pronunciationAudioId;

  @BelongsTo(MediaFileBean)
  int birdCallAudioId;

  /// List of all media files used in this entries gallery
  @ManyToMany(EntryToMediaPivotBean, MediaFileBean)
  List<MediaFile> galleryImages;
}

/// Bean class for database manipulation - generated mixin code
@GenBean()
class FactFileEntryBean extends Bean<FactFileEntry> with _FactFileEntryBean {
  FactFileEntryBean(Adapter adapter)
      : mediaFileBean = MediaFileBean(adapter),
        entryToMediaPivotBean = EntryToMediaPivotBean(adapter),
        super(adapter);

  final MediaFileBean mediaFileBean;
  final EntryToMediaPivotBean entryToMediaPivotBean;

  FactFileCategoryBean _factFileCategoryBean;
  FactFileCategoryBean get factFileCategoryBean =>
      _factFileCategoryBean ??= FactFileCategoryBean(adapter);

  final String tableName = 'fact_file_entries';
}
