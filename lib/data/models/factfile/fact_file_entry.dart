import 'package:discover_deep_cove/data/models/factfile/fact_file_entry_images.dart';
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
  int listenAudioId;

  /// List of all media files used in this entries gallery
  @ManyToMany(FactFileEntryImageBean, MediaFileBean)
  List<MediaFile> galleryImages;

  @IgnoreColumn()
  MediaFile mainImage;

  @IgnoreColumn()
  MediaFile pronunciationAudio;

  @IgnoreColumn()
  MediaFile listenAudio;

  @IgnoreColumn()
  FactFileCategory category;
}

/// Bean class for database manipulation - generated mixin code
@GenBean()
class FactFileEntryBean extends Bean<FactFileEntry> with _FactFileEntryBean {
  FactFileEntryBean(Adapter adapter)
      : mediaFileBean = MediaFileBean(adapter),
        factFileEntryImageBean = FactFileEntryImageBean(adapter),
        super(adapter);

  final MediaFileBean mediaFileBean;
  final FactFileEntryImageBean factFileEntryImageBean;

  FactFileCategoryBean _factFileCategoryBean;
  FactFileCategoryBean get factFileCategoryBean =>
      _factFileCategoryBean ??= FactFileCategoryBean(adapter);

  final String tableName = 'fact_file_entries';

  /// Find the [FactFileEntry] that belongs to the supplied [id], and returns
  /// it preloaded with all media file relationships.
  Future<FactFileEntry> findAndPreload(int id) async {
    FactFileEntry entry = await find(id, preload: true);
    entry = await preloadExtras(entry);

    return entry;
  }

  /// Returns all [FactFileEntry] objects in the database, preloading all
  /// relationships.
  Future<List<FactFileEntry>> getAllAndPreload() async {
    List<FactFileEntry> entries = await preloadAll(await getAll());

    for (FactFileEntry entry in entries) {
      entry = await preloadExtras(entry);
    }

    return entries;
  }

  Future<FactFileEntry> preloadExtras(FactFileEntry entry) async {
    entry.category = await factFileCategoryBean.find(entry.categoryId);
    entry.mainImage = await mediaFileBean.find(entry.mainImageId);
    entry.pronunciationAudio =
        await mediaFileBean.find(entry.pronunciationAudioId);
    entry.listenAudio = await mediaFileBean.find(entry.listenAudioId);

    return entry;
  }
}
