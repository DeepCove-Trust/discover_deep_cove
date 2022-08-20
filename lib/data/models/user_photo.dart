import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:meta/meta.dart';

import '../database_adapter.dart';
import 'activity/activity.dart';

part 'user_photo.jorm.dart';

class UserPhoto {
  UserPhoto();

  UserPhoto.create({@required this.path});

  @PrimaryKey(auto: true)
  int id;

  @Column()
  String path;

  @HasMany(ActivityBean)
  List<Activity> activities;
}

@GenBean()
class UserPhotoBean extends Bean<UserPhoto> with _UserPhotoBean {
  UserPhotoBean(Adapter adapter)
      : activityBean = ActivityBean(adapter),
        super(adapter);

  UserPhotoBean.of(BuildContext context)
      : activityBean = ActivityBean.of(context),
        super(DatabaseAdapter.of(context));

  final ActivityBean activityBean;

  final String tableName = 'user_photos';
}
