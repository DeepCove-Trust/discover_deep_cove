import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/models/notice.dart';
import '../env.dart';
import 'local_notifications.dart';
import 'network_util.dart';

class NoticeboardSync {
  static Future<void> retrieveNotices(BuildContext context) async {
    bool shouldRefresh = false;
    bool hasNew = false;
    debugPrint('Checking for new notices');

    try {
      NoticeBean bean = NoticeBean.of(context);

      // Ensure that table exists
      bean.createTable(ifNotExists: true);

      // Check if server can be reached
      if (await NetworkUtil.canAccessCMSRemote()) {
        // Download list of notices
        String jsonString = await NetworkUtil.requestDataString(Env.getNoticesUrl());
        List<dynamic> data = jsonDecode(jsonString);
        List<Notice> remoteNotices = data.map((m) => bean.fromMap(m)).toList();

        // Gather local notices
        List<Notice> localNotices = await bean.getAll();

        // Compare with existing notices
        for (Notice notice in remoteNotices) {
          if (!localNotices.any((n) => n.id == notice.id)) {
            shouldRefresh = true;
            hasNew = true;
          } else if (localNotices.firstWhere((n) => n.id == notice.id).updatedAt.isBefore(notice.updatedAt)) {
            shouldRefresh = true;
            hasNew = true;
          }
        }

        for (Notice notice in localNotices) {
          if (!remoteNotices.any((n) => n.id == notice.id)) {
            shouldRefresh = true;
          }
        }

        if (shouldRefresh) {
          await _refreshNotices(bean, remoteNotices, context, hasNew);
        }
      }
    } catch (ex, trace) {
      debugPrint('Error checking for new notices: $ex');
      debugPrint(trace.toString());
    }
  }

  static Future<void> _refreshNotices(
      NoticeBean bean, List<Notice> remoteNotices, BuildContext context, bool showNotification) async {
    try {
      // Remove all local notices and replace with remote
      await bean.removeAll();
      await bean.insertMany(remoteNotices);

      if (showNotification) {
        LocalNotifications.showNotification(
            title: 'New notices available',
            body: 'Visit the noticeboard in Discover Deep Cove!',
            payload: 'Notice',
            context: context);
      }
    } catch (ex, trace) {
      debugPrint('Error refreshing notices: $ex');
      debugPrint(trace.toString());
    }
  }
}
