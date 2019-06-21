import 'package:discover_deep_cove/data/models/factfile/fact_file_entry_images.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_nugget.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:meta/meta.dart';

part 'media_file.jorm.dart';

/// The media file types supported by the application.
/// TODO: Monitor Jaguar's support of enum persistence
enum MediaFileType {
  jpg,
  png,
  mp3,
}

/// A media file that is stored on the device.
class MediaFile {
  MediaFile();

  MediaFile.make(
      {@required this.id,
      @required this.type,
      @required this.path,
      this.description});

  @PrimaryKey()
  int id;

  /// TODO: Persist as a [MediaFileType] enum when Jaguar supports it.
  /// The file type.
  @Column()
  String type;

  /// Description of the media file's contents.
  @Column()
  String description;

  /// Path to the file, relative to the apps root storage directory.
  @Column()
  String path;

  /// List of the entries that use this media file as their main image.
  /// TODO: Should these be using @BelongsTo.many() ???
  @HasMany(FactFileEntryBean)
  List<FactFileEntry> mainImageEntries;

  /// List of the entries that use this media file for their bird call.
  @HasMany(FactFileEntryBean)
  List<FactFileEntry> listenEntries;

  /// List of the entries that use this media file for their pronunciation.
  @HasMany(FactFileEntryBean)
  List<FactFileEntry> pronunciationEntries;

  /// List of the entries that use this media file in their image gallery.
  @ManyToMany(FactFileEntryImageBean, FactFileEntryBean)
  List<FactFileEntry> galleryImageEntries;

  /// List of the fact file nuggets that use this media file as their image.
  @HasMany(FactFileNuggetBean)
  List<FactFileNugget> nuggets;
}

/// Bean class used for database manipulation - auto generated mixin code
@GenBean()
class MediaFileBean extends Bean<MediaFile> with _MediaFileBean {
  MediaFileBean(Adapter adapter)
      : factFileNuggetBean = FactFileNuggetBean(adapter),
        factFileEntryBean = FactFileEntryBean(adapter),
        factFileEntryImageBean = FactFileEntryImageBean(adapter),
        super(adapter);

  final FactFileNuggetBean factFileNuggetBean;
  final FactFileEntryBean factFileEntryBean;
  final FactFileEntryImageBean factFileEntryImageBean;

  final String tableName = 'media_files';
}
