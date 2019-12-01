import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:meta/meta.dart';

import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'notice.jorm.dart';

class Notice {
  Notice();

  Notice.make({
    @required this.id,
    @required this.urgent,
    @required this.imageId,
    @required this.activatedAt,
    @required this.title,
    @required this.shortDesc,
    @required this.longDesc,
  }) : dismissed = false;

  @PrimaryKey()
  int id;

  @Column()
  bool urgent;

  @Column()
  bool dismissed;

  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  @Column()
  DateTime activatedAt;

  @Column()
  String title;

  @Column()
  String shortDesc;

  @Column(isNullable: true)
  String longDesc;

  @IgnoreColumn()
  MediaFile image;
}

@GenBean()
class NoticeBean extends Bean<Notice> with _NoticeBean {
  NoticeBean(Adapter adapter) : super(adapter);

  NoticeBean.of(BuildContext context)
      : super(DatabaseAdapter.of(context));

  MediaFileBean _mediaFileBean;

  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'notices';

  Future<List<Notice>> preloadExtrasForRange(List<Notice> notices) async {
    for(Notice notice in notices){
      await preloadExtras(notice);
    }
    return notices;
  }

  Future<Notice> preloadExtras(Notice notice) async {
    notice.image = await mediaFileBean.find(notice.imageId);
    return notice;
  }
}