import 'package:meta/meta.dart';
import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';

part 'activity_image.jorm.dart';

class ActivityImage {
  @BelongsTo(ActivityBean)
  int activityId;

  @BelongsTo(MediaFileBean)
  int imageId;

  ActivityImage();

  ActivityImage.make({@required this.imageId, @required this.activityId});
}

@GenBean()
class ActivityImageBean extends Bean<ActivityImage> with _ActivityImageBean {
  ActivityImageBean(Adapter adapter) : super(adapter);

  ActivityImageBean.of(BuildContext context)
      : super(DatabaseAdapter.of(context));

  ActivityBean _activityBean;

  ActivityBean get activityBean => _activityBean ?? ActivityBean(adapter);

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'activity_images';
}
