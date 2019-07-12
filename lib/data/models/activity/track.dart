import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'track.jorm.dart';

class Track {
  Track();

  @PrimaryKey()
  int id;

  @Column()
  String name;

  @HasMany(ActivityBean)
  List<Activity> activities;
}

@GenBean()
class TrackBean extends Bean<Track> with _TrackBean {
  TrackBean(Adapter adapter)
      : activityBean = ActivityBean(adapter),
        super(adapter);

  final ActivityBean activityBean;

  final String tableName = 'tracks';
}
