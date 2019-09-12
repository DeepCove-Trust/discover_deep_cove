import 'dart:io';

import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/util/data_sync.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

// Todo: This screen should replicate the splash screen.
class _SplashState extends State<Splash> {
  String text = 'Opening application...';
  Icon icon;

  @override
  void initState() {
    super.initState();
    checkContent();
  }

  // Check whether the database exists
  Future<void> checkContent() async {
    // Check whether database file exists and push the home screen if so
    try {
      await ConfigBean.of(context).find(1);
      Navigator.of(context).popAndPushNamed('/');
    } catch (ex) {
      if (ex is DatabaseException) {
        // Database hasn't been built
        setState(() {
          text = 'Downloading application content.\n\n'
              'This may take several minutes.';
        });

        bool wasSuccessful = await SyncProvider.syncResources();

        if (wasSuccessful) {
          setState(() {
            text = 'Application up to date';
            icon = Icon(Icons.check, color: Colors.green, size: 50);
          });
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).popAndPushNamed('/');
        } else {
          setState(() {
            text = 'An error occurred.\n\nPlease try again later.'; //
            icon = Icon(Icons.error_outline, color: Colors.red, size: 50);
          });
          await Future.delayed(
            Duration(seconds: 2),
          );
          exit(0);
        }
      } else {
        throw ex; // otherwise, throw the exception
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/splash_logo.png'),
            Column(
              children: [
                icon ?? CircularProgressIndicator(),
                SizedBox(
                  height: Screen.height(context, percentage: 10),
                ),
                BodyText(
                  text,
                  size: Screen.isTablet(context) ? 30 : null,
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }
}
