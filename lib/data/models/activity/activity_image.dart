import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:meta/meta.dart';

import '../../database_adapter.dart';
import '../media_file.dart';
import 'activity.dart';

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

  ActivityImageBean.of(BuildContext context) : super(DatabaseAdapter.of(context));

  ActivityBean _activityBean;

  ActivityBean get activityBean => _activityBean ?? ActivityBean(adapter);

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'activity_images';
}
