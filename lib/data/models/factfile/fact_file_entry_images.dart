import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

part 'fact_file_entry_images.jorm.dart';

/// Pivot table between fact file entries and the media files that belong to
/// their galleries.
class FactFileEntryImage {
  FactFileEntryImage();

  // Todo: Confirm whether these two should be BelongsTo.many
  @BelongsTo(FactFileEntryBean)
  int factFileEntryId;

  @BelongsTo(MediaFileBean)
  int mediaFileId;
}

/// Bean class for database manipulation.
@GenBean()
class FactFileEntryImageBean extends Bean<FactFileEntryImage>
    with _FactFileEntryImageBean {
  FactFileEntryImageBean(Adapter adapter) : super(adapter);

  FactFileEntryBean _factFileEntryBean;
  FactFileEntryBean get factFileEntryBean =>
      _factFileEntryBean ??= FactFileEntryBean(adapter);

  MediaFileBean _mediaFileBean;
  MediaFileBean get mediaFileBean => _mediaFileBean ??= MediaFileBean(adapter);

  final String tableName = 'entry_images';
}
