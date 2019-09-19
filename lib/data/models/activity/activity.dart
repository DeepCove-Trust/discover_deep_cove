import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/activity/activity_image.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/user_photo.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:latlong/latlong.dart' show LatLng;

part 'activity.jorm.dart';

enum ActivityType {
  informational,
  countActivity,
  photographActivity,
  pictureSelectActivity,
  pictureTapActivity,
  textAnswerActivity
}

class Activity {
  @PrimaryKey()
  int id;

  @Column()
  DateTime lastModified;

  @BelongsTo(TrackBean)
  int trackId;

  @Column(isNullable: true)
  int factFileId;

  @Column(name: 'activityType')
  int _activityType;

  @IgnoreColumn()
  ActivityType get activityType => ActivityType.values[_activityType];

  @Column()
  String qrCode;

  @Column()
  double coordX;

  @Column()
  double coordY;

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
  @BelongsTo(UserPhotoBean, isNullable: true)
  int userPhotoId;

  /// The selected picture for a picture select activity.
  @BelongsTo(MediaFileBean, isNullable: true)
  int selectedPictureId;

  @Column()
  bool informationActivityUnlocked;

  @Column(isNullable: true)
  double userCoordX;

  @Column(isNullable: true)
  double userCoordY;

  @Column(isNullable: true)
  int userCount;

  @Column(isNullable: true)
  String userText;

  @ManyToMany(ActivityImageBean, MediaFileBean)
  List<MediaFile> imageOptions;

  @IgnoreColumn()
  MediaFile image; // Todo: preload this

  @IgnoreColumn()
  MediaFile selectedPicture; // Todo: preload this

  @IgnoreColumn()
  UserPhoto userPhoto; // Todo: preload this

  @IgnoreColumn()
  LatLng get latLng => LatLng(coordY, coordX);

  bool isCompleted() {
    switch (activityType) {
      case ActivityType.pictureSelectActivity:
        return selectedPictureId != null;
        break;
      case ActivityType.pictureTapActivity:
        return userCoordX != null && userCoordY != null;
        break;
      case ActivityType.countActivity:
        return userCount != null;
        break;
      case ActivityType.textAnswerActivity:
        return userText != null;
        break;
      case ActivityType.photographActivity:
        return userPhotoId != null;
        break;
      case ActivityType.informational:
        return informationActivityUnlocked;
        break;
      default:
        return false;
    }
  }

  clearProgress() {
    userPhotoId = null;
    userPhoto = null;
    userCount = null;
    userCoordY = null;
    userCoordX = null;
    userText = null;
    selectedPictureId = null;
    selectedPicture = null;
    informationActivityUnlocked = false;
  }
}

@GenBean()
class ActivityBean extends Bean<Activity> with _ActivityBean {
  ActivityBean(Adapter adapter)
      : activityImageBean = ActivityImageBean(adapter),
        super(adapter);

  ActivityBean.of(BuildContext context)
      : activityImageBean = ActivityImageBean(DatabaseAdapter.of(context)),
        super(DatabaseAdapter.of(context));

  final ActivityImageBean activityImageBean;

  TrackBean _trackBean;

  TrackBean get trackBean => _trackBean ?? TrackBean(adapter);

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  UserPhotoBean _userPhotoBean;

  UserPhotoBean get userPhotoBean => _userPhotoBean ?? UserPhotoBean(adapter);

  final String tableName = 'activities';

  Future<Activity> preloadRelationships(Activity activity) async {
    activity = await preload(activity);

    if (activity.imageId != null) {
      activity.image = await mediaFileBean.find(activity.imageId);
    }

    if (activity.userPhotoId != null) {
      activity.userPhoto = await userPhotoBean.find(activity.userPhotoId);
    }

    if (activity.selectedPictureId != null) {
      activity.selectedPicture =
          await mediaFileBean.find(activity.selectedPictureId);
    }

    return activity;
  }
}
