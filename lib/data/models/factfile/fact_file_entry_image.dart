import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

import '../../database_adapter.dart';
import '../media_file.dart';
import 'fact_file_entry.dart';

part 'fact_file_entry_image.jorm.dart';

/// Pivot table between fact file entries and the media files that belong to
/// their galleries.
class FactFileEntryImage {
  FactFileEntryImage();

  FactFileEntryImage.make(int factFileId, int mediaFileId)
      : factFileEntryId = factFileId,
        mediaFileId = mediaFileId;

  // Todo: Confirm whether these two should be BelongsTo.many
  @BelongsTo(FactFileEntryBean)
  int factFileEntryId;

  @BelongsTo(MediaFileBean)
  int mediaFileId;
}

/// Bean class for database manipulation.
@GenBean()
class FactFileEntryImageBean extends Bean<FactFileEntryImage> with _FactFileEntryImageBean {
  FactFileEntryImageBean(Adapter adapter) : super(adapter);

  FactFileEntryImageBean.of(BuildContext context) : super(DatabaseAdapter.of(context));

  FactFileEntryBean _factFileEntryBean;

  FactFileEntryBean get factFileEntryBean => _factFileEntryBean ??= FactFileEntryBean(adapter);

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ??= MediaFileBean(adapter);

  final String tableName = 'entry_images';
}
