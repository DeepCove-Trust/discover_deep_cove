import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/route_generator.dart';
import 'package:discover_deep_cove/util/screen.dart';
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

  runApp(
    DatabaseAdapter(
      adapter: await DB.instance.adapter,
      child: MaterialApp(
        title: Env.appName,
        theme: appTheme(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ),
  );
}

ThemeData appTheme() {
  return ThemeData(
    //Green
    primaryColor: HexColor("FF8BC34A"),
    //Charcoal
    primaryColorDark: HexColor("FF262626"),
    //Orange
    accentColor: HexColor("FFFF5026"),
    //Dark Gray
    backgroundColor: HexColor("FF363636"),

    fontFamily: 'Roboto',

    textTheme: TextTheme(
      headline: TextStyle(fontSize: 30, color: Colors.white),
      body1: TextStyle(fontSize: 16, color: Colors.white),
      subhead: TextStyle(fontSize: 25, color: Colors.white),
    ),
  );
}
