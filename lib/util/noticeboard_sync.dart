import 'dart:convert';

import 'package:discover_deep_cove/data/models/notice.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/local_notifications.dart';
import 'package:discover_deep_cove/util/network_util.dart';
import 'package:flutter/cupertino.dart';

class NoticeboardSync {
  static void retrieveNotices(BuildContext context) async {
    bool hasUpdated = false;
    if (Env.debugMessages) print('Checking for new notices');

    try {
      NoticeBean bean = NoticeBean.of(context);

      // Ensure that table exists
      bean.createTable(ifNotExists: true);

      // Check if server can be reached
      if (await NetworkUtil.canAccessCMSRemote()) {
        // Download list of notices
        String jsonString =
            await NetworkUtil.requestDataString(Env.getNoticesUrl());
        List<dynamic> data = jsonDecode(jsonString);
        List<Notice> remoteNotices = data.map((m) => bean.fromMap(m)).toList();

        // Gather local notices
        List<Notice> localNotices = await bean.getAll();

        // Compare with existing notices
        for (Notice notice in remoteNotices) {
          if (!localNotices.any((n) => n.id == notice.id)) {
            hasUpdated = true;
          } else if (localNotices
              .firstWhere((n) => n.id == notice.id)
              .updatedAt
              .isBefore(notice.updatedAt)) {
            hasUpdated = true;
          }
        }

        if (hasUpdated) {
          // Remove all local notices and replace with remote

          await bean.removeAll();

          await bean.insertMany(remoteNotices);

          LocalNotifications.showNotification(
            title: 'New notices available',
            body: 'Visit the noticeboard in Discover Deep Cove!',
            payload: 'Notice',
            context: context,
          );
        }

        // Notify user if new notices are downloaded

      } else {
        // No internet connection, aborting
        return;
      }
    } catch (ex, trace) {
      print('Error checking for new notices: $ex');
      print(trace);
    }
  }
}
