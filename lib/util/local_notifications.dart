import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin _notifications;
  static BuildContext _context;

  static initializeNotifications() {
    _notifications = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('icon');

    var initializationSettings =
    InitializationSettings(initializationSettingsAndroid, null);

    _notifications.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  //  onPressed: () => LocalNotifications.showOngoingNotification(title: 'Test',body: "Test", cntxt: context, payload: 'Notice'),

  static Future _onSelectNotification(String payload) async {
    switch (payload) {
      case "Notice":
        await Navigator.of(_context).pushNamed('/noticeboard');
        break;

      case "Content":
      //TODO: decide which route to pass
    }
  }

  static NotificationDetails get _notice {
    final androidChannelSpecifics = AndroidNotificationDetails(
      '0',
      'Notices',
      'New notice notification',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: true,
      color: Color(0xFF8BC34A),
    );

    return NotificationDetails(androidChannelSpecifics, null);
  }

  static NotificationDetails get _download {
    final androidChannelSpecifics = AndroidNotificationDetails(
      '1',
      'New content',
      'New content available notification',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: true,
      color: Color(0xFF8BC34A),
    );

    return NotificationDetails(androidChannelSpecifics, null);
  }

  static Future showNotification({
    @required String title,
    @required String body,
    @required String payload,
    @required BuildContext context,
    int id = 0,
  }) {
    _context = context;

    return _displayNotification(
        title: title,
        body: body,
        id: id,
        type: payload == "Notice" ? _notice : _download,
        payload: payload);
  }

  static Future _displayNotification({
    @required String title,
    @required String body,
    @required NotificationDetails type,
    @required String payload,
    int id = 0,
  }) =>
      _notifications.show(id, title, body, type, payload: payload);
}