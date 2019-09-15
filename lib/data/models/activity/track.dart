import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:flutter/material.dart' show BuildContext;
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

  TrackBean.of(BuildContext context)
      : activityBean = ActivityBean(DatabaseAdapter.of(context)),
        super(DatabaseAdapter.of(context));

  Future<List<Track>> getAllAndPreload() async {
    List<Track> tracks = await getAll();
    tracks = await preloadAll(tracks);
    return tracks;
  }

  final ActivityBean activityBean;

  final String tableName = 'tracks';
}
