import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';

import 'package:meta/meta.dart';

import '../../database_adapter.dart';
import '../media_file.dart';
import 'fact_file_category.dart';
import 'fact_file_entry_image.dart';
import 'fact_file_nugget.dart';

part 'fact_file_entry.jorm.dart';

/// An entry in the 'Deep Cove Factfiles'
class FactFileEntry {
  /// Used by bean only. Use FactFileEntry.make() instead.
  FactFileEntry();

  FactFileEntry.make({
    @required this.id,
    @required this.categoryId,
    @required this.updatedAt,
    @required this.primaryName,
    @required this.bodyText,
  });

  @PrimaryKey()
  int id;

  @BelongsTo(FactFileCategoryBean)
  int categoryId;

  @Column()
  DateTime updatedAt;

  @Column()
  String primaryName;

  @Column(isNullable: true)
  String altName;

  @Column()
  String bodyText;

  @BelongsTo(MediaFileBean)
  int mainImageId;

  @BelongsTo(MediaFileBean, isNullable: true)
  int pronounceAudioId;

  @BelongsTo(MediaFileBean, isNullable: true)
  int listenAudioId;

  /// List of all media files used in this entries gallery
  @ManyToMany(FactFileEntryImageBean, MediaFileBean)
  List<MediaFile> galleryImages;

  /// List of the fact file nuggets that will be displayed on this fact file
  /// entry page.
  @HasMany(FactFileNuggetBean)
  List<FactFileNugget> nuggets;

  @IgnoreColumn()
  MediaFile mainImage;

  @IgnoreColumn()
  MediaFile pronounceAudio;

  @IgnoreColumn()
  MediaFile listenAudio;

  @IgnoreColumn()
  FactFileCategory category;

  bool hasAudioClips() => hasPronouceClip() || hasListenClip();
  bool hasPronouceClip() => pronounceAudioId != null;
  bool hasListenClip() => listenAudioId != null;
}

/// Bean class for database manipulation - generated mixin code
@GenBean()
class FactFileEntryBean extends Bean<FactFileEntry> with _FactFileEntryBean {
  FactFileEntryBean(Adapter adapter)
      : factFileEntryImageBean = FactFileEntryImageBean(adapter),
        factFileNuggetBean = FactFileNuggetBean(adapter),
        super(adapter);

  FactFileEntryBean.of(BuildContext context)
      : factFileEntryImageBean = FactFileEntryImageBean(DatabaseAdapter.of(context)),
        factFileNuggetBean = FactFileNuggetBean(DatabaseAdapter.of(context)),
        super(DatabaseAdapter.of(context));

  final FactFileEntryImageBean factFileEntryImageBean;
  final FactFileNuggetBean factFileNuggetBean;

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  FactFileCategoryBean _factFileCategoryBean;

  FactFileCategoryBean get factFileCategoryBean => _factFileCategoryBean ??= FactFileCategoryBean(adapter);

  final String tableName = 'fact_file_entries';

  /// Find the [FactFileEntry] that belongs to the supplied [id], and returns
  /// it preloaded with all media file relationships.
  Future<FactFileEntry> findAndPreload(int id) async {
    FactFileEntry entry = await find(id, preload: true);
    entry = await _preloadExtras(entry);

    return entry;
  }

  /// Returns all [FactFileEntry] objects in the database, preloading all
  /// relationships.
  Future<List<FactFileEntry>> getAllAndPreload() async {
    List<FactFileEntry> entries = await preloadAll(await getAll());

    for (FactFileEntry entry in entries) {
      entry = await _preloadExtras(entry);
    }
    return entries;
  }

  Future<List<FactFileEntry>> preloadExtras(List<FactFileEntry> entries) async {
    for (FactFileEntry entry in entries) {
      entry = await _preloadExtras(entry);
    }
    return entries;
  }

  Future<FactFileEntry> _preloadExtras(FactFileEntry entry) async {
    entry = await preload(entry);

    entry.category = await factFileCategoryBean.find(entry.categoryId);

    entry.mainImage = await mediaFileBean.find(entry.mainImageId);

    if (entry.pronounceAudioId != null) entry.pronounceAudio = await mediaFileBean.find(entry.pronounceAudioId);

    if (entry.listenAudioId != null) entry.listenAudio = await mediaFileBean.find(entry.listenAudioId);

    for (FactFileNugget nugget in entry.nuggets) {
      nugget = await factFileNuggetBean.preloadImage(nugget);
    }

    // Sort nuggets by order index
    entry.nuggets.sort((a, b) => a.orderIndex - b.orderIndex);

    return entry;
  }
}
