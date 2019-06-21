import 'package:discover_deep_cove/data/models/activity/activity_images.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'activity.jorm.dart';

class Activity {
  @PrimaryKey()
  int id;

  @BelongsTo(TrackBean)
  int trackId;

  @Column()
  String discriminator;

  @Column()
  String qrCode;

  @Column()
  double xCoord;

  @Column()
  double yCoord;

  @Column()
  String title;

  @Column()
  String description;

  @Column(isNullable: true)
  String task;

  /// The image to display with the activity description.
  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  /// The image that the user took for this activity.
  @BelongsTo(MediaFileBean, isNullable: true)
  int userPhotoId;

  /// The selected picture for a picture select activity.
  @BelongsTo(MediaFileBean, isNullable: true)
  int selectedPictureId;

  @Column(isNullable: true)
  double userXCoord;

  @Column(isNullable: true)
  double userYCoord;

  @Column(isNullable: true)
  int userCount;

  @Column(isNullable: true)
  String userText;

  @ManyToMany(ActivityImageBean, MediaFileBean)
  List<MediaFile> imageOptions;

  bool isCompleted(){

    switch(discriminator){
      case 'pictureSelect': {
        return selectedPictureId != null;
      }
      break;
      case 'pictureTap': {
        return userXCoord != null && userYCoord != null;
      }
      break;
      case 'count': {
        return userCount != null;
      }
      break;
      case 'textAnswer': {
        return userText != null;
      }
      break;
      case 'photograph': {
        return userPhotoId != null;
      }
      break;
      default: {
        return false;
      }
    }

  }
}

@GenBean()
class ActivityBean extends Bean<Activity> with _ActivityBean {
  ActivityBean(Adapter adapter)
      : activityImageBean = ActivityImageBean(adapter),
        super(adapter);

  final ActivityImageBean activityImageBean;

  TrackBean _trackBean;
  TrackBean get trackBean => _trackBean ?? TrackBean(adapter);

  MediaFileBean _mediaFileBean;
  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'activities';
}
