import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:meta/meta.dart';

part 'config.jorm.dart';

class Config {
  Config();

  Config.make({
    @required this.id,
    @required this.dataVersion,
    @required this.filesVersion,
    @required this.masterUnlockCode,
  });

  @PrimaryKey()
  int id;

  @Column()
  int dataVersion;

  @Column()
  int filesVersion;

  @Column()
  String masterUnlockCode;
}

@GenBean()
class ConfigBean extends Bean<Config> with _ConfigBean {
  ConfigBean(Adapter adapter) : super(adapter);

  ConfigBean.of(BuildContext context) : super(DatabaseAdapter.of(context));

  final String tableName = 'config';
}
