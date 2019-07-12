import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/data_sync.dart';
import 'package:discover_deep_cove/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  // Initialize the env singleton
  await DotEnv().load('.env');

//  await SyncProvider.syncResources();

  runApp(
    DatabaseAdapter(
      adapter: await DB.instance.adapter,
      child: MaterialApp(
        title: Env.appName,
        home: HomePage(
            title: Env.appName), // TODO: Add home page class when built
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 0, 79, 47),
          primaryColorDark: Color.fromARGB(255, 0, 79, 47),
          primaryColorLight: Color.fromARGB(100, 5, 102, 36),
        ),
      ),
    ),
  );
}
