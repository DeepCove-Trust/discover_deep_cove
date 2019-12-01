import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/local_notifications.dart';
import 'package:discover_deep_cove/util/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Initialize the env singleton
  await DotEnv().load('.env');

  // Preload directories for env
  await Env.load();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //Initializes local notifications
  LocalNotifications.initializeNotifications();

  if(DotEnv().env['debugStorageMode'] == 'true'){
    print('Warning: Debug storage mode enabled. Disable for production release.');
  }

  runApp(
    DatabaseAdapter(
      adapter: await DB.instance.adapter,
      child: MaterialApp(
        title: Env.appName,
        theme: appTheme(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ),
  );
}

ThemeData appTheme() {
  return ThemeData(
    //Green
    primaryColor: Color(0xFF8BC34A),
    //Charcoal
    primaryColorDark: Color(0xFF262626),
    //Orange
    accentColor: Color(0xFFFF5026),
    //Dark Gray
    backgroundColor: Color(0xFF363636),
    //Urgent notice color
    indicatorColor: Colors.red,
    //Grey text color
    primaryColorLight: Color(0xFF999999),

    fontFamily: 'Roboto',
  );
}
