import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:meta/meta.dart';

import '../database_adapter.dart';

part 'config.jorm.dart';

class Config {
  Config();

  Config.make({@required this.id, @required this.masterUnlockCode});

  @PrimaryKey()
  int id;

  @Column()
  String masterUnlockCode;

  @Column(name: 'save_photos_to_gallery', isNullable: true)
  bool _savePhotosToGallery;
  bool get savePhotosToGallery => _savePhotosToGallery ?? false;
  set savePhotosToGallery(bool val) => _savePhotosToGallery = val;
}

@GenBean()
class ConfigBean extends Bean<Config> with _ConfigBean {
  ConfigBean(Adapter adapter) : super(adapter);

  ConfigBean.of(BuildContext context) : super(DatabaseAdapter.of(context));

  final String tableName = 'config';
}
