import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/database_adapter.dart';
import 'data/db.dart';
import 'env.dart';
import 'util/local_notifications.dart';
import 'util/route_generator.dart';

void main() async {
  // Initialize the env singleton
  await DotEnv().load();

  // Preload directories for env
  await Env.load();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //Initializes local notifications
  LocalNotifications.initializeNotifications();

  if (DotEnv().env['debugStorageMode'] == 'true') {
    debugPrint('Warning: Debug storage mode enabled. Disable for production release.');
  }

  if (DotEnv().env['debugMessgaes'] == 'true') {
    debugPrint('Warning: Debug messages enabled. Disable for production release.');
  }

  runApp(
    DatabaseAdapter(
      adapter: await getDbAdaptor(),
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
    primaryColor: const Color(0xFF8BC34A),
    //Charcoal
    primaryColorDark: const Color(0xFF262626),
    //Dark Gray
    backgroundColor: const Color(0xFF363636),
    //Urgent notice color
    indicatorColor: Colors.red,
    //Grey text color
    primaryColorLight: const Color(0xFF999999),

    fontFamily: 'Roboto', colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFF5026)),
  );
}

Future<SqfliteAdapter> getDbAdaptor() async {
  try {
    return await DB.instance.adapter;
  } catch (ex) {
    SystemNavigator.pop();
    return null;
  }
}
