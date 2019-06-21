import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:meta/meta.dart';

part 'fact_file_nugget.jorm.dart';

class FactFileNugget {
  FactFileNugget();

  FactFileNugget.make(
      {@required this.id, @required this.factFileEntryId, @required this.text});

  @PrimaryKey()
  int id;

  /// Foreign key reference to the fact file entry to which the nugget belongs.
  @BelongsTo(FactFileEntryBean)
  int factFileEntryId;

  /// Foreign key reference to the image used in the nugget. Optional.
  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  /// Determines the order in which the nuggets will display on the fact file
  /// entry page.
  @Column()
  int orderIndex;

  /// Optional text that will appear as a heading for the nugget section.
  @Column()
  String name;

  /// The body content of the nugget section.
  @Column()
  String text;

  /// The entry to which this nugget belongs.
  @IgnoreColumn()
  FactFileEntry factFileEntry;

  /// The image used by this nugget.
  @IgnoreColumn()
  MediaFile image;
}

@GenBean()
class FactFileNuggetBean extends Bean<FactFileNugget> with _FactFileNuggetBean {
  FactFileNuggetBean(Adapter adapter)
      : factFileEntryBean = FactFileEntryBean(adapter),
        mediaFileBean = MediaFileBean(adapter),
        super(adapter);

  final FactFileEntryBean factFileEntryBean;
  final MediaFileBean mediaFileBean;

  final String tableName = 'fact_file_nuggets';
}
